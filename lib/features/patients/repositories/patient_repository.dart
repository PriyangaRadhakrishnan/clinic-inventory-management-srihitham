import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/patient_model.dart';

class PatientRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPatient(PatientModel patient) async {
    await _firestore.collection('patients').add(patient.toMap());
  }

  Future<void> updatePatient(PatientModel patient) async {
    await _firestore.collection('patients').doc(patient.id).update(patient.toMap());
  }

  Future<void> deletePatient(String id) async {
    await _firestore.collection('patients').doc(id).delete();
  }

  Stream<List<PatientModel>> getPatients() {
    return _firestore.collection('patients').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => PatientModel.fromMap(doc.data(), doc.id)).toList();
    });
  }
}