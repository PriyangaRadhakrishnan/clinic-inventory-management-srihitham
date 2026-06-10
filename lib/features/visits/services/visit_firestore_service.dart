import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_collections.dart';
import '../../../core/services/id_service.dart';
import '../models/visit_model.dart';

class VisitFirestoreService {
  final FirebaseFirestore _firestore;

  VisitFirestoreService({
    FirebaseFirestore? firestore,
    IdService? idService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<String> addVisit(VisitModel visit) async {
    final patientId = visit.patientId;

    // 1. Query the existing visits collection outside the transaction to find the max visit number for this patient.
    // This is for fallback/compatibility if the counter document does not exist yet.
    final querySnapshot = await _firestore
        .collection(FirestoreCollections.visits)
        .where('patientId', isEqualTo: patientId)
        .get();

    int maxExistingCount = 0;
    for (final doc in querySnapshot.docs) {
      final data = doc.data();
      final visitIdStr = data['visitId'] as String?;
      if (visitIdStr != null && visitIdStr.startsWith('V')) {
        final numericPart = int.tryParse(visitIdStr.substring(1));
        if (numericPart != null && numericPart > maxExistingCount) {
          maxExistingCount = numericPart;
        }
      }
    }

    final counterRef = _firestore.collection('counters').doc('visits_$patientId');

    // 2. Transactionally get or set the counter and write the visit document
    final formattedId = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(counterRef);
      int nextCount;
      if (snapshot.exists) {
        final currentCount = snapshot.data()?['count'] ?? 0;
        nextCount = currentCount + 1;
        transaction.update(counterRef, {'count': nextCount});
      } else {
        nextCount = maxExistingCount + 1;
        transaction.set(counterRef, {'count': nextCount});
      }

      final formattedIdVal = 'V${nextCount.toString().padLeft(4, '0')}';
      final docId = '${patientId}_$formattedIdVal';

      final newVisit = visit.copyWith(
        id: docId,
        visitId: formattedIdVal,
      );

      final visitDocRef = _firestore.collection(FirestoreCollections.visits).doc(docId);
      transaction.set(visitDocRef, newVisit.toMap());

      return formattedIdVal;
    });

    return formattedId;
  }

  Stream<List<VisitModel>> getVisitsByPatient(String patientId) {
    return _firestore
        .collection(FirestoreCollections.visits)
        .where('patientId', isEqualTo: patientId)
        .snapshots()
        .map(
          (snapshot) {
            final visits = snapshot.docs
                .map(
                  (doc) => VisitModel.fromMap(
                    doc.data(),
                    doc.id,
                  ),
                )
                .toList();
            // Sort in memory by visitDate descending
            visits.sort((a, b) => b.visitDate.compareTo(a.visitDate));
            return visits;
          },
        );
  }

  Future<void> updateVisit(VisitModel visit) async {
    await _firestore
        .collection(FirestoreCollections.visits)
        .doc(visit.id)
        .update(visit.toMap());
  }

  Future<void> deleteVisit(String visitId) async {
    await _firestore
        .collection(FirestoreCollections.visits)
        .doc(visitId)
        .delete();
  }
}
