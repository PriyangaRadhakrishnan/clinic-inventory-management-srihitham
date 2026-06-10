import 'package:cloud_firestore/cloud_firestore.dart';

class PatientModel {
  final String id;
  final String patientId; // SH20250001
  final String name;
  final int age;
  final String gender;
  final String phone;
  final DateTime dateOfBirth;
  final String address;
  final DateTime registrationDate;

  PatientModel({
    required this.id,
    required this.patientId,
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
    required this.dateOfBirth,
    required this.address,
    required this.registrationDate,
  });

  factory PatientModel.fromMap(Map<String, dynamic> map, String documentId) {
    return PatientModel(
      id: documentId,
      patientId: map['patientId'] ?? '',
      name: map['name'] ?? '',
      age: map['age']?.toInt() ?? 0,
      gender: map['gender'] ?? '',
      phone: map['phone'] ?? '',
      dateOfBirth: (map['dateOfBirth'] as Timestamp).toDate(),
      address: map['address'] ?? '',
      registrationDate: (map['registrationDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'name': name,
      'age': age,
      'gender': gender,
      'phone': phone,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'address': address,
      'registrationDate': Timestamp.fromDate(registrationDate),
    };
  }
}
