import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clinic_inventory/features/patients/models/patient_model.dart';
import 'package:clinic_inventory/features/visits/models/visit_model.dart';

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

  group('VisitModel Tests', () {
    test('VisitModel parses correctly with all fields provided', () {
      final visitDate = DateTime(2025, 2, 10, 10, 30);
      final followUpDate = DateTime(2025, 2, 17);
      final createdAt = DateTime(2025, 2, 10, 10, 35);
      final map = {
        'visitId': 'V20250001',
        'patientId': 'SH20250001',
        'visitDate': Timestamp.fromDate(visitDate),
        'symptoms': 'Fever and cough',
        'diagnosis': 'Common cold',
        'prescriptionNotes': 'Rest and hydration',
        'followUpDate': Timestamp.fromDate(followUpDate),
        'createdAt': Timestamp.fromDate(createdAt),
      };

      final visit = VisitModel.fromMap(map, 'doc_visit_123');

      expect(visit.id, 'doc_visit_123');
      expect(visit.visitId, 'V20250001');
      expect(visit.patientId, 'SH20250001');
      expect(visit.visitDate, visitDate);
      expect(visit.symptoms, 'Fever and cough');
      expect(visit.diagnosis, 'Common cold');
      expect(visit.prescriptionNotes, 'Rest and hydration');
      expect(visit.followUpDate, followUpDate);
      expect(visit.createdAt, createdAt);
    });

    test('VisitModel parses correctly when optional followUpDate is null', () {
      final visitDate = DateTime(2025, 2, 10, 10, 30);
      final createdAt = DateTime(2025, 2, 10, 10, 35);
      final map = {
        'visitId': 'V20250001',
        'patientId': 'SH20250001',
        'visitDate': Timestamp.fromDate(visitDate),
        'symptoms': 'Fever and cough',
        'diagnosis': 'Common cold',
        'prescriptionNotes': 'Rest and hydration',
        'followUpDate': null,
        'createdAt': Timestamp.fromDate(createdAt),
      };

      final visit = VisitModel.fromMap(map, 'doc_visit_123');

      expect(visit.id, 'doc_visit_123');
      expect(visit.followUpDate, isNull);
    });

    test('VisitModel toMap contains correct keys and values', () {
      final visitDate = DateTime(2025, 2, 10, 10, 30);
      final followUpDate = DateTime(2025, 2, 17);
      final createdAt = DateTime(2025, 2, 10, 10, 35);
      final visit = VisitModel(
        id: 'doc_visit_123',
        visitId: 'V20250001',
        patientId: 'SH20250001',
        visitDate: visitDate,
        symptoms: 'Fever and cough',
        diagnosis: 'Common cold',
        prescriptionNotes: 'Rest and hydration',
        followUpDate: followUpDate,
        createdAt: createdAt,
      );

      final map = visit.toMap();

      expect(map['visitId'], 'V20250001');
      expect(map['patientId'], 'SH20250001');
      expect(map['visitDate'], isA<Timestamp>());
      expect((map['visitDate'] as Timestamp).toDate(), visitDate);
      expect(map['symptoms'], 'Fever and cough');
      expect(map['diagnosis'], 'Common cold');
      expect(map['prescriptionNotes'], 'Rest and hydration');
      expect(map['followUpDate'], isA<Timestamp>());
      expect((map['followUpDate'] as Timestamp).toDate(), followUpDate);
      expect(map['createdAt'], isA<Timestamp>());
      expect((map['createdAt'] as Timestamp).toDate(), createdAt);
    });
  });
}
