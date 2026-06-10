import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:clinic_inventory/features/patients/models/patient_model.dart';
import 'package:clinic_inventory/features/visits/models/visit_model.dart';
import 'package:clinic_inventory/features/visits/views/visit_details_view.dart';

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
        'doctorNotes': 'Drink warm fluids',
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
      expect(visit.doctorNotes, 'Drink warm fluids');
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
        'doctorNotes': 'Drink warm fluids',
        'followUpDate': null,
        'createdAt': Timestamp.fromDate(createdAt),
      };

      final visit = VisitModel.fromMap(map, 'doc_visit_123');

      expect(visit.id, 'doc_visit_123');
      expect(visit.followUpDate, isNull);
    });

    test('VisitModel parses correctly when optional doctorNotes is missing (simulating legacy records)', () {
      final visitDate = DateTime(2025, 2, 10, 10, 30);
      final createdAt = DateTime(2025, 2, 10, 10, 35);
      final map = {
        'visitId': 'V20250001',
        'patientId': 'SH20250001',
        'visitDate': Timestamp.fromDate(visitDate),
        'symptoms': 'Fever and cough',
        'diagnosis': 'Common cold',
        // doctorNotes omitted
        'followUpDate': null,
        'createdAt': Timestamp.fromDate(createdAt),
      };

      final visit = VisitModel.fromMap(map, 'doc_visit_123');

      expect(visit.id, 'doc_visit_123');
      expect(visit.doctorNotes, '');
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
        doctorNotes: 'Drink warm fluids',
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
      expect(map['doctorNotes'], 'Drink warm fluids');
      expect(map['followUpDate'], isA<Timestamp>());
      expect((map['followUpDate'] as Timestamp).toDate(), followUpDate);
      expect(map['createdAt'], isA<Timestamp>());
      expect((map['createdAt'] as Timestamp).toDate(), createdAt);
    });
  });

  group('VisitDetailsView Widget Tests', () {
    testWidgets('displays all clinical visit details including Patient ID correctly', (WidgetTester tester) async {
      final visit = VisitModel(
        id: 'SH20250001_V0002',
        visitId: 'V0002',
        patientId: 'SH20250001',
        visitDate: DateTime(2026, 6, 10),
        symptoms: 'Mild head ache',
        diagnosis: 'Migraine aura',
        doctorNotes: 'Take medicine daily',
        followUpDate: DateTime(2026, 6, 17),
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(MaterialApp(
        home: VisitDetailsView(visit: visit),
      ));

      // Verify header and basic info
      expect(find.text('Visit Details'), findsOneWidget);
      expect(find.text('Clinical Visit Details'), findsOneWidget);

      // Verify Patient ID is displayed
      expect(find.text('Patient ID'), findsOneWidget);
      expect(find.text('SH20250001'), findsOneWidget);

      // Verify Visit ID
      expect(find.text('Visit ID'), findsOneWidget);
      expect(find.text('V0002'), findsOneWidget);

      // Verify Symptoms
      expect(find.text('Symptoms'), findsOneWidget);
      expect(find.text('Mild head ache'), findsOneWidget);

      // Verify Diagnosis
      expect(find.text('Diagnosis'), findsOneWidget);
      expect(find.text('Migraine aura'), findsOneWidget);

      // Verify Doctor Notes
      expect(find.text('Doctor Notes'), findsOneWidget);
      expect(find.text('Take medicine daily'), findsOneWidget);

      // Verify Visit Date
      expect(find.text('Visit Date'), findsOneWidget);
      expect(find.text('10-Jun-2026'), findsOneWidget);

      // Verify Follow-up Date
      expect(find.text('Follow-up Date'), findsOneWidget);
      expect(find.text('17-Jun-2026'), findsOneWidget);
    });

    testWidgets('displays placeholders when optional fields are empty or null', (WidgetTester tester) async {
      final visit = VisitModel(
        id: 'SH20250001_V0002',
        visitId: 'V0002',
        patientId: 'SH20250001',
        visitDate: DateTime(2026, 6, 10),
        symptoms: '',
        diagnosis: '',
        doctorNotes: '',
        followUpDate: null,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(MaterialApp(
        home: VisitDetailsView(visit: visit),
      ));

      // Verify empty field fallbacks/placeholders
      expect(find.text('None recorded'), findsNWidgets(3)); // Symptoms, Diagnosis, Doctor Notes
      expect(find.text('None scheduled'), findsOneWidget); // Follow-up Date
    });
  });
}
