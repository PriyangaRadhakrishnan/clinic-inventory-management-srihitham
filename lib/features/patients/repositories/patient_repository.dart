import '../models/patient_model.dart';

abstract class PatientRepository {
  Future<String> addPatient(PatientModel patient);
  Future<void> updatePatient(PatientModel patient);
  Future<void> deletePatient(String patientId);
  Future<PatientModel?> getPatientById(String patientId);
  Stream<List<PatientModel>> getPatients();
  Future<List<PatientModel>> searchPatients(String query);
}