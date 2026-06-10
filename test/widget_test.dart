import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:clinic_inventory/features/patients/models/patient_model.dart';
import 'package:clinic_inventory/features/visits/models/visit_model.dart';
import 'package:clinic_inventory/features/visits/views/visit_details_view.dart';
import 'package:clinic_inventory/features/prescriptions/models/prescription_model.dart';

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

      // Verify Prescription History section and placeholder
      expect(find.text('Prescription History'), findsOneWidget);
      expect(find.text('No prescriptions recorded'), findsOneWidget);
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

      // Verify Prescription History section and placeholder
      expect(find.text('Prescription History'), findsOneWidget);
      expect(find.text('No prescriptions recorded'), findsOneWidget);
    });
  });

  group('PrescriptionModel Tests', () {
    test('PrescribedMedicine parses correctly from map', () {
      final map = {
        'medicineId': 'med_1',
        'name': 'Aspirin',
        'dosage': '1-0-1',
        'duration': '5 days',
        'instruction': 'After meals',
      };
      final med = PrescribedMedicine.fromMap(map);
      expect(med.medicineId, 'med_1');
      expect(med.name, 'Aspirin');
      expect(med.dosage, '1-0-1');
      expect(med.duration, '5 days');
      expect(med.instruction, 'After meals');
    });

    test('PrescriptionModel parses typed prescription correctly with safe optional fields', () {
      final date = DateTime(2026, 6, 10);
      final created = DateTime(2026, 6, 10, 12, 0);
      final map = {
        'prescriptionId': 'PR0001',
        'patientId': 'SH20250001',
        'visitId': 'SH20250001_V0001',
        'prescriptionDate': Timestamp.fromDate(date),
        'type': 'typed',
        'medicines': [
          {
            'medicineId': 'med_1',
            'name': 'Aspirin',
            'dosage': '1-0-1',
            'duration': '5 days',
            'instruction': 'After meals',
          }
        ],
        'fileUrl': null,
        'fileType': null,
        'additionalNotes': 'Drink water',
        'createdAt': Timestamp.fromDate(created),
      };

      final model = PrescriptionModel.fromMap(map, 'doc_xyz');
      expect(model.id, 'doc_xyz');
      expect(model.prescriptionId, 'PR0001');
      expect(model.patientId, 'SH20250001');
      expect(model.visitId, 'SH20250001_V0001');
      expect(model.prescriptionDate, date);
      expect(model.type, PrescriptionType.typed);
      expect(model.medicines.length, 1);
      expect(model.medicines[0].name, 'Aspirin');
      expect(model.fileUrl, isNull);
      expect(model.fileType, isNull);
      expect(model.additionalNotes, 'Drink water');
      expect(model.createdAt, created);
    });

    test('PrescriptionModel parses upload/camera type and handles null safety and fallbacks', () {
      final date = DateTime(2026, 6, 10);
      final map = {
        'prescriptionId': 'PR0002',
        'patientId': 'SH20250001',
        'visitId': 'SH20250001_V0001',
        'prescriptionDate': Timestamp.fromDate(date),
        'type': 'upload',
        // medicines is missing
        'fileUrl': 'https://example.com/prescription.pdf',
        'fileType': 'pdf',
        'additionalNotes': null,
        // createdAt is missing
      };

      final model = PrescriptionModel.fromMap(map, 'doc_abc');
      expect(model.id, 'doc_abc');
      expect(model.type, PrescriptionType.upload);
      expect(model.medicines, isEmpty); // fallback to empty list
      expect(model.fileUrl, 'https://example.com/prescription.pdf');
      expect(model.fileType, 'pdf');
      expect(model.additionalNotes, isNull);
      expect(model.createdAt, isNotNull); // fallback to DateTime.now()
    });

    test('PrescriptionModel handles safe enum parsing for unknown type strings', () {
      final map = {
        'prescriptionId': 'PR0003',
        'patientId': 'SH20250001',
        'visitId': 'SH20250001_V0001',
        'type': 'unknown_type_value', // invalid enum name
      };

      final model = PrescriptionModel.fromMap(map, 'doc_def');
      expect(model.type, PrescriptionType.typed); // defaults to typed
    });

    test('PrescriptionModel toMap serializes enum and dates correctly', () {
      final date = DateTime(2026, 6, 10);
      final created = DateTime(2026, 6, 10, 12, 0);
      final model = PrescriptionModel(
        id: 'doc_1',
        prescriptionId: 'PR0001',
        patientId: 'SH20250001',
        visitId: 'SH20250001_V0001',
        prescriptionDate: date,
        type: PrescriptionType.camera,
        medicines: [],
        fileUrl: 'https://example.com/photo.jpg',
        fileType: 'image/jpeg',
        additionalNotes: 'Urgent',
        createdAt: created,
      );

      final map = model.toMap();
      expect(map['prescriptionId'], 'PR0001');
      expect(map['patientId'], 'SH20250001');
      expect(map['visitId'], 'SH20250001_V0001');
      expect(map['prescriptionDate'], isA<Timestamp>());
      expect((map['prescriptionDate'] as Timestamp).toDate(), date);
      expect(map['type'], 'camera');
      expect(map['medicines'], isEmpty);
      expect(map['fileUrl'], 'https://example.com/photo.jpg');
      expect(map['fileType'], 'image/jpeg');
      expect(map['additionalNotes'], 'Urgent');
      expect(map['createdAt'], isA<Timestamp>());
      expect((map['createdAt'] as Timestamp).toDate(), created);
    });
  });
}
