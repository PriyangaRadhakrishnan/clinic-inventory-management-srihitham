import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clinic_inventory/features/prescriptions/models/prescription_model.dart';
import 'package:clinic_inventory/features/prescriptions/services/prescription_firestore_service.dart';
import 'package:clinic_inventory/core/constants/firestore_collections.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late PrescriptionFirestoreService prescriptionFirestoreService;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    prescriptionFirestoreService =
        PrescriptionFirestoreService(firestore: fakeFirestore);
  });

  group('PrescriptionFirestoreService - ID Generation and Storage Tests', () {
    test('generate sequential prescription IDs globally and verify document IDs',
        () async {
      final rx1 = PrescriptionModel(
        id: '',
        prescriptionId: '',
        patientId: 'SH20250001',
        visitId: 'SH20250001_V0001',
        prescriptionDate: DateTime(2026, 6, 10),
        type: PrescriptionType.typed,
        medicines: [],
        createdAt: DateTime.now(),
      );

      final id1 = await prescriptionFirestoreService.addPrescription(rx1);
      expect(id1, 'P0001');

      // Verify document exists with correct document ID and fields
      final doc1 = await fakeFirestore
          .collection(FirestoreCollections.prescriptions)
          .doc('P0001')
          .get();
      expect(doc1.exists, isTrue);
      expect(doc1.data()?['prescriptionId'], 'P0001');
      expect(doc1.data()?['patientId'], 'SH20250001');
      expect(doc1.data()?['visitId'], 'SH20250001_V0001');

      // Verify counter document is initialized to 1
      final counter = await fakeFirestore
          .collection(FirestoreCollections.counters)
          .doc('prescriptions')
          .get();
      expect(counter.exists, isTrue);
      expect(counter.data()?['count'], 1);

      // Add second prescription
      final rx2 = PrescriptionModel(
        id: '',
        prescriptionId: '',
        patientId: 'SH20250002',
        visitId: 'SH20250002_V0001',
        prescriptionDate: DateTime(2026, 6, 11),
        type: PrescriptionType.upload,
        medicines: [],
        createdAt: DateTime.now(),
      );

      final id2 = await prescriptionFirestoreService.addPrescription(rx2);
      expect(id2, 'P0002');

      final doc2 = await fakeFirestore
          .collection(FirestoreCollections.prescriptions)
          .doc('P0002')
          .get();
      expect(doc2.exists, isTrue);
      expect(doc2.data()?['prescriptionId'], 'P0002');

      // Verify counter increments to 2
      final counter2 = await fakeFirestore
          .collection(FirestoreCollections.counters)
          .doc('prescriptions')
          .get();
      expect(counter2.data()?['count'], 2);
    });

    test('compatibility with legacy prescriptions (no counter document)',
        () async {
      // Manually seed a legacy prescription in Firestore (no counter document exists yet)
      await fakeFirestore
          .collection(FirestoreCollections.prescriptions)
          .doc('P0007')
          .set({
        'prescriptionId': 'P0007',
        'patientId': 'SH20250001',
        'visitId': 'SH20250001_V0001',
        'prescriptionDate': Timestamp.fromDate(DateTime(2026, 6, 8)),
        'type': 'typed',
        'medicines': [],
        'createdAt': Timestamp.fromDate(DateTime(2026, 6, 8)),
      });

      final newRx = PrescriptionModel(
        id: '',
        prescriptionId: '',
        patientId: 'SH20250001',
        visitId: 'SH20250001_V0002',
        prescriptionDate: DateTime(2026, 6, 10),
        type: PrescriptionType.camera,
        medicines: [],
        createdAt: DateTime.now(),
      );

      final newId = await prescriptionFirestoreService.addPrescription(newRx);
      // Since legacy max was P0007, the new prescription should be P0008
      expect(newId, 'P0008');

      final newDoc = await fakeFirestore
          .collection(FirestoreCollections.prescriptions)
          .doc('P0008')
          .get();
      expect(newDoc.exists, isTrue);

      // Verify counter document is now set to 8
      final counter = await fakeFirestore
          .collection(FirestoreCollections.counters)
          .doc('prescriptions')
          .get();
      expect(counter.exists, isTrue);
      expect(counter.data()?['count'], 8);
    });
  });

  group('PrescriptionFirestoreService - Query and Delete Tests', () {
    const patient1 = 'SH20250001';
    const patient2 = 'SH20250002';
    const visit1 = 'SH20250001_V0001';
    const visit2 = 'SH20250001_V0002';

    setUp(() async {
      // Seed some test documents
      await fakeFirestore
          .collection(FirestoreCollections.prescriptions)
          .doc('P0001')
          .set({
        'prescriptionId': 'P0001',
        'patientId': patient1,
        'visitId': visit1,
        'prescriptionDate': Timestamp.fromDate(DateTime(2026, 6, 10)),
        'type': 'typed',
        'medicines': [],
        'createdAt': Timestamp.fromDate(DateTime(2026, 6, 10)),
      });

      await fakeFirestore
          .collection(FirestoreCollections.prescriptions)
          .doc('P0002')
          .set({
        'prescriptionId': 'P0002',
        'patientId': patient1,
        'visitId': visit2,
        'prescriptionDate': Timestamp.fromDate(DateTime(2026, 6, 11)),
        'type': 'upload',
        'medicines': [],
        'createdAt': Timestamp.fromDate(DateTime(2026, 6, 11)),
      });

      await fakeFirestore
          .collection(FirestoreCollections.prescriptions)
          .doc('P0003')
          .set({
        'prescriptionId': 'P0003',
        'patientId': patient2,
        'visitId': 'SH20250002_V0001',
        'prescriptionDate': Timestamp.fromDate(DateTime(2026, 6, 12)),
        'type': 'camera',
        'medicines': [],
        'createdAt': Timestamp.fromDate(DateTime(2026, 6, 12)),
      });
    });

    test('getPrescriptionsByVisit returns matching prescriptions sorted by date descending',
        () async {
      final stream = prescriptionFirestoreService.getPrescriptionsByVisit(visit1);
      final list = await stream.first;

      expect(list.length, 1);
      expect(list[0].prescriptionId, 'P0001');
      expect(list[0].visitId, visit1);
    });

    test('getPrescriptionsByPatient returns matching prescriptions sorted by date descending',
        () async {
      final stream = prescriptionFirestoreService.getPrescriptionsByPatient(patient1);
      final list = await stream.first;

      expect(list.length, 2);
      // P0002 date (June 11) is newer than P0001 date (June 10), so it should be first
      expect(list[0].prescriptionId, 'P0002');
      expect(list[1].prescriptionId, 'P0001');
    });

    test('deletePrescription removes the document correctly', () async {
      // Ensure P0001 exists
      final checkExistsBefore = await fakeFirestore
          .collection(FirestoreCollections.prescriptions)
          .doc('P0001')
          .get();
      expect(checkExistsBefore.exists, isTrue);

      // Delete P0001
      await prescriptionFirestoreService.deletePrescription('P0001');

      // Verify deleted
      final checkExistsAfter = await fakeFirestore
          .collection(FirestoreCollections.prescriptions)
          .doc('P0001')
          .get();
      expect(checkExistsAfter.exists, isFalse);
    });
  });
}
