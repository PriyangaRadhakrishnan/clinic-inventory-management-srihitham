import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_collections.dart';
import '../../../core/services/id_service.dart';
import '../models/patient_model.dart';
import '../repositories/patient_repository.dart';

class PatientFirestoreService implements PatientRepository {
  final FirebaseFirestore _firestore;
  final IdService _idService;

  PatientFirestoreService({
    FirebaseFirestore? firestore,
    IdService? idService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _idService = idService ?? IdService();

  @override
  Future<String> addPatient(PatientModel patient) async {
    final patientId = await _idService.generateNextId('patients');

    final newPatient = patient.copyWith(id: patientId);

    await _firestore
        .collection(FirestoreCollections.patients)
        .doc(patientId)
        .set(newPatient.toMap());

    return patientId;
  }

  @override
  Future<void> updatePatient(PatientModel patient) async {
    await _firestore
        .collection(FirestoreCollections.patients)
        .doc(patient.id)
        .update(patient.toMap());
  }

  @override
  Future<void> deletePatient(String patientId) async {
    await _firestore
        .collection(FirestoreCollections.patients)
        .doc(patientId)
        .delete();
  }

  @override
  Future<PatientModel?> getPatientById(String patientId) async {
    final doc = await _firestore
        .collection(FirestoreCollections.patients)
        .doc(patientId)
        .get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return PatientModel.fromMap(
      doc.data()!,
      doc.id,
    );
  }

  @override
  Stream<List<PatientModel>> getPatients() {
    return _firestore
        .collection(FirestoreCollections.patients)
        .orderBy('registrationDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => PatientModel.fromMap(
                  doc.data(),
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  @override
  Future<List<PatientModel>> searchPatients(String query) async {
    final snapshot = await _firestore
        .collection(FirestoreCollections.patients)
        .get();

    return snapshot.docs
        .map(
          (doc) => PatientModel.fromMap(
            doc.data(),
            doc.id,
          ),
        )
        .where(
          (patient) =>
              patient.id.toLowerCase().contains(query.toLowerCase()) ||
              patient.name.toLowerCase().contains(query.toLowerCase()) ||
              patient.phone.contains(query),
        )
        .toList();
  }
}