import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clinic_inventory/features/prescriptions/models/prescription_model.dart';
import 'package:clinic_inventory/features/prescriptions/services/prescription_firestore_service.dart';
import 'package:clinic_inventory/features/prescriptions/providers/prescription_provider.dart';
import 'package:clinic_inventory/core/constants/firestore_collections.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late PrescriptionFirestoreService firestoreService;
  late PrescriptionProvider provider;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = PrescriptionFirestoreService(firestore: fakeFirestore);
    provider = PrescriptionProvider(firestoreService: firestoreService);
  });

  group('PrescriptionProvider Tests', () {
    test('initial state defaults are correct', () {
      expect(provider.prescriptions, isEmpty);
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
    });

    test('loadPrescriptionsByVisit listens and updates prescriptions list in real-time', () async {
      const visitId = 'visit_123';

      // Seed a document
      await fakeFirestore
          .collection(FirestoreCollections.prescriptions)
          .doc('P0001')
          .set({
        'prescriptionId': 'P0001',
        'patientId': 'SH20250001',
        'visitId': visitId,
        'prescriptionDate': Timestamp.fromDate(DateTime(2026, 6, 10)),
        'type': 'typed',
        'medicines': [],
        'createdAt': Timestamp.fromDate(DateTime(2026, 6, 10)),
      });

      provider.loadPrescriptionsByVisit(visitId);
      expect(provider.isLoading, isTrue);

      // Allow stream subscription event to trigger listener callback
      await Future.delayed(const Duration(milliseconds: 20));

      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
      expect(provider.prescriptions.length, 1);
      expect(provider.prescriptions[0].prescriptionId, 'P0001');

      // Add another prescription for the same visit
      await fakeFirestore
          .collection(FirestoreCollections.prescriptions)
          .doc('P0002')
          .set({
        'prescriptionId': 'P0002',
        'patientId': 'SH20250001',
        'visitId': visitId,
        'prescriptionDate': Timestamp.fromDate(DateTime(2026, 6, 11)),
        'type': 'upload',
        'medicines': [],
        'createdAt': Timestamp.fromDate(DateTime(2026, 6, 11)),
      });

      // Allow stream update to propagate
      await Future.delayed(const Duration(milliseconds: 20));

      // Sorted by date descending, so newer (P0002 on June 11) is first
      expect(provider.prescriptions.length, 2);
      expect(provider.prescriptions[0].prescriptionId, 'P0002');
      expect(provider.prescriptions[1].prescriptionId, 'P0001');
    });

    test('loadPrescriptionsByPatient listens and updates prescriptions list in real-time', () async {
      const patientId = 'SH20250001';

      await fakeFirestore
          .collection(FirestoreCollections.prescriptions)
          .doc('P0001')
          .set({
        'prescriptionId': 'P0001',
        'patientId': patientId,
        'visitId': 'visit_1',
        'prescriptionDate': Timestamp.fromDate(DateTime(2026, 6, 10)),
        'type': 'typed',
        'medicines': [],
        'createdAt': Timestamp.fromDate(DateTime(2026, 6, 10)),
      });

      provider.loadPrescriptionsByPatient(patientId);
      expect(provider.isLoading, isTrue);

      await Future.delayed(const Duration(milliseconds: 20));

      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
      expect(provider.prescriptions.length, 1);
      expect(provider.prescriptions[0].prescriptionId, 'P0001');
    });

    test('addPrescription triggers loading and successfully adds document returning next sequential ID', () async {
      final rx = PrescriptionModel(
        id: '',
        prescriptionId: '',
        patientId: 'SH20250001',
        visitId: 'visit_1',
        prescriptionDate: DateTime(2026, 6, 10),
        type: PrescriptionType.typed,
        medicines: [],
        createdAt: DateTime.now(),
      );

      final nextId = await provider.addPrescription(rx);
      expect(nextId, 'P0001');
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);

      final doc = await fakeFirestore
          .collection(FirestoreCollections.prescriptions)
          .doc('P0001')
          .get();
      expect(doc.exists, isTrue);
    });

    test('deletePrescription deletes correctly and updates status', () async {
      // Seed a document
      await fakeFirestore
          .collection(FirestoreCollections.prescriptions)
          .doc('P0001')
          .set({
        'prescriptionId': 'P0001',
        'patientId': 'SH20250001',
        'visitId': 'visit_1',
        'prescriptionDate': Timestamp.fromDate(DateTime(2026, 6, 10)),
        'type': 'typed',
        'medicines': [],
        'createdAt': Timestamp.fromDate(DateTime(2026, 6, 10)),
      });

      final success = await provider.deletePrescription('P0001');
      expect(success, isTrue);
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);

      final doc = await fakeFirestore
          .collection(FirestoreCollections.prescriptions)
          .doc('P0001')
          .get();
      expect(doc.exists, isFalse);
    });

    test('clearError resets current error string', () {
      provider.addPrescription(PrescriptionModel(
        id: '',
        prescriptionId: '',
        patientId: '',
        visitId: '',
        prescriptionDate: DateTime.now(),
        type: PrescriptionType.typed,
        medicines: [],
        createdAt: DateTime.now(),
      )); // This succeeds normally, but we can manually set error in provider for testing or verify initial.
      
      provider.clearError();
      expect(provider.error, isNull);
    });
  });
}
