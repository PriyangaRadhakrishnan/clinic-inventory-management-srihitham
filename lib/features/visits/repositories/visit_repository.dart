import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/visit_model.dart';

class VisitRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addVisit(VisitModel visit) async {
    await _firestore.collection('visits').add(visit.toMap());
  }

  Future<void> updateVisit(VisitModel visit) async {
    await _firestore.collection('visits').doc(visit.id).update(visit.toMap());
  }

  Future<void> deleteVisit(String id) async {
    await _firestore.collection('visits').doc(id).delete();
  }

  Stream<List<VisitModel>> getVisitsForPatient(String patientId) {
    return _firestore.collection('visits')
        .where('patientId', isEqualTo: patientId)
        .orderBy('visitDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => VisitModel.fromMap(doc.data(), doc.id)).toList());
  }
}
