import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_collections.dart';
import '../../../core/services/id_service.dart';
import '../models/visit_model.dart';

class VisitFirestoreService {
  final FirebaseFirestore _firestore;
  final IdService _idService;

  VisitFirestoreService({
    FirebaseFirestore? firestore,
    IdService? idService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _idService = idService ?? IdService();

  Future<String> addVisit(VisitModel visit) async {
    final rawId = await _idService.generateNextId('visits');
    final count = int.tryParse(rawId.replaceFirst('V', '')) ?? 1;
    final formattedId = 'V${count.toString().padLeft(4, '0')}';

    final newVisit = visit.copyWith(
      id: formattedId,
      visitId: formattedId,
    );

    await _firestore
        .collection(FirestoreCollections.visits)
        .doc(formattedId)
        .set(newVisit.toMap());

    return formattedId;
  }

  Stream<List<VisitModel>> getVisitsByPatient(String patientId) {
    return _firestore
        .collection(FirestoreCollections.visits)
        .where('patientId', isEqualTo: patientId)
        .orderBy('visitDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => VisitModel.fromMap(
                  doc.data(),
                  doc.id,
                ),
              )
              .toList(),
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
