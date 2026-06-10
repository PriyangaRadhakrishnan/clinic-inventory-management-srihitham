import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clinic_inventory/features/patients/models/patient_model.dart';

void main() {
  group('PatientModel Tests', () {
    test('PatientModel parses correctly with all fields provided', () {
      final date = DateTime(1990, 5, 20);
      final regDate = DateTime(2025, 1, 1);
      final map = {
        'patientId': 'SH20250001',
        'name': 'John Doe',
        'age': 34,
        'gender': 'Male',
        'phone': '1234567890',
        'dateOfBirth': Timestamp.fromDate(date),
        'address': '123 Main St',
        'registrationDate': Timestamp.fromDate(regDate),
      };

      final patient = PatientModel.fromMap(map, 'doc_123');

      expect(patient.id, 'doc_123');
      expect(patient.patientId, 'SH20250001');
      expect(patient.name, 'John Doe');
      expect(patient.age, 34);
      expect(patient.gender, 'Male');
      expect(patient.phone, '1234567890');
      expect(patient.dateOfBirth, date);
      expect(patient.address, '123 Main St');
      expect(patient.registrationDate, regDate);
    });

    test('PatientModel parses correctly when optional fields (gender, address) are missing (simulating legacy records)', () {
      final date = DateTime(1990, 5, 20);
      final regDate = DateTime(2025, 1, 1);
      final map = {
        'patientId': 'SH20250001',
        'name': 'John Doe',
        'age': 34,
        // gender and address omitted
        'phone': '1234567890',
        'dateOfBirth': Timestamp.fromDate(date),
        'registrationDate': Timestamp.fromDate(regDate),
      };

      final patient = PatientModel.fromMap(map, 'doc_123');

      expect(patient.id, 'doc_123');
      expect(patient.gender, '');
      expect(patient.address, '');
    });

    test('PatientModel toMap contains correct keys and values', () {
      final date = DateTime(1990, 5, 20);
      final regDate = DateTime(2025, 1, 1);
      final patient = PatientModel(
        id: 'doc_123',
        patientId: 'SH20250001',
        name: 'John Doe',
        age: 34,
        gender: '',
        phone: '1234567890',
        dateOfBirth: date,
        address: '',
        registrationDate: regDate,
      );

      final map = patient.toMap();

      expect(map['patientId'], 'SH20250001');
      expect(map['name'], 'John Doe');
      expect(map['age'], 34);
      expect(map['gender'], '');
      expect(map['phone'], '1234567890');
      expect(map['dateOfBirth'], isA<Timestamp>());
      expect((map['dateOfBirth'] as Timestamp).toDate(), date);
      expect(map['address'], '');
      expect(map['registrationDate'], isA<Timestamp>());
      expect((map['registrationDate'] as Timestamp).toDate(), regDate);
    });
  });
}
