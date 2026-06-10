import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clinic_inventory/features/visits/models/visit_model.dart';
import 'package:clinic_inventory/features/visits/services/visit_firestore_service.dart';
import 'package:clinic_inventory/core/constants/firestore_collections.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late VisitFirestoreService visitFirestoreService;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    visitFirestoreService = VisitFirestoreService(firestore: fakeFirestore);
  });

  group('VisitFirestoreService - Per-Patient Sequential ID Tests', () {
    test('generate sequential visit IDs per patient and verify composite document IDs', () async {
      const patientA = 'SH20250001';
      const patientB = 'SH20250002';

      // 1. Add first visit for Patient A
      final visitA1 = VisitModel(
        id: '',
        visitId: '',
        patientId: patientA,
        visitDate: DateTime(2026, 6, 10),
        symptoms: 'Headache',
        diagnosis: 'Migraine',
        doctorNotes: 'Rest',
        createdAt: DateTime.now(),
      );

      final idA1 = await visitFirestoreService.addVisit(visitA1);
      expect(idA1, 'V0001');

      // Verify document exists with correct composite ID and fields
      final docA1 = await fakeFirestore.collection(FirestoreCollections.visits).doc('${patientA}_V0001').get();
      expect(docA1.exists, isTrue);
      expect(docA1.data()?['visitId'], 'V0001');
      expect(docA1.data()?['patientId'], patientA);

      // Verify counter document is initialized to 1
      final counterA = await fakeFirestore.collection('counters').doc('visits_$patientA').get();
      expect(counterA.exists, isTrue);
      expect(counterA.data()?['count'], 1);

      // 2. Add second visit for Patient A
      final visitA2 = VisitModel(
        id: '',
        visitId: '',
        patientId: patientA,
        visitDate: DateTime(2026, 6, 11),
        symptoms: 'Fever',
        diagnosis: 'Flu',
        doctorNotes: 'Flu fluids',
        createdAt: DateTime.now(),
      );

      final idA2 = await visitFirestoreService.addVisit(visitA2);
      expect(idA2, 'V0002');

      final docA2 = await fakeFirestore.collection(FirestoreCollections.visits).doc('${patientA}_V0002').get();
      expect(docA2.exists, isTrue);
      expect(docA2.data()?['visitId'], 'V0002');

      // Verify counter increments
      final counterA2 = await fakeFirestore.collection('counters').doc('visits_$patientA').get();
      expect(counterA2.data()?['count'], 2);

      // 3. Add first visit for Patient B
      final visitB1 = VisitModel(
        id: '',
        visitId: '',
        patientId: patientB,
        visitDate: DateTime(2026, 6, 10),
        symptoms: 'Cough',
        diagnosis: 'Cold',
        doctorNotes: 'Syrup',
        createdAt: DateTime.now(),
      );

      final idB1 = await visitFirestoreService.addVisit(visitB1);
      expect(idB1, 'V0001'); // Patient B starts at V0001

      final docB1 = await fakeFirestore.collection(FirestoreCollections.visits).doc('${patientB}_V0001').get();
      expect(docB1.exists, isTrue);

      final counterB = await fakeFirestore.collection('counters').doc('visits_$patientB').get();
      expect(counterB.data()?['count'], 1);
    });

    test('compatibility with legacy visits (no counter document)', () async {
      const patientA = 'SH20250001';

      // Manually seed legacy visit document in Firestore (no counter document exists yet)
      const legacyVisitId = 'V0005';
      const compositeLegacyDocId = '${patientA}_$legacyVisitId';
      await fakeFirestore.collection(FirestoreCollections.visits).doc(compositeLegacyDocId).set({
        'visitId': legacyVisitId,
        'patientId': patientA,
        'visitDate': Timestamp.fromDate(DateTime(2026, 6, 8)),
        'symptoms': 'Back pain',
        'diagnosis': 'Muscle strain',
        'doctorNotes': '',
        'createdAt': Timestamp.fromDate(DateTime(2026, 6, 8)),
      });

      // Add new visit for Patient A
      final newVisit = VisitModel(
        id: '',
        visitId: '',
        patientId: patientA,
        visitDate: DateTime(2026, 6, 10),
        symptoms: 'Sore throat',
        diagnosis: 'Pharyngitis',
        doctorNotes: 'Antibiotics',
        createdAt: DateTime.now(),
      );

      final newId = await visitFirestoreService.addVisit(newVisit);
      // Since legacy visit was V0005, the new visit should be V0006
      expect(newId, 'V0006');

      final newDoc = await fakeFirestore.collection(FirestoreCollections.visits).doc('${patientA}_V0006').get();
      expect(newDoc.exists, isTrue);

      // Verify counter document is now set to 6
      final counter = await fakeFirestore.collection('counters').doc('visits_$patientA').get();
      expect(counter.exists, isTrue);
      expect(counter.data()?['count'], 6);
    });
  });
}
