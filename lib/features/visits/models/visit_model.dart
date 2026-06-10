import 'package:cloud_firestore/cloud_firestore.dart';

class VisitModel {
  final String id;
  final String visitId; // V1
  final String patientId;
  final String doctorId;
  final DateTime visitDate;
  final String symptoms;
  final String diagnosis;
  final double consultationFee;
  final String prescriptionNotes;
  final List<String> prescriptionImageUrls;
  final String? linkedBillId;

  VisitModel({
    required this.id,
    required this.visitId,
    required this.patientId,
    required this.doctorId,
    required this.visitDate,
    required this.symptoms,
    required this.diagnosis,
    required this.consultationFee,
    required this.prescriptionNotes,
    required this.prescriptionImageUrls,
    this.linkedBillId,
  });

  factory VisitModel.fromMap(Map<String, dynamic> map, String documentId) {
    return VisitModel(
      id: documentId,
      visitId: map['visitId'] ?? '',
      patientId: map['patientId'] ?? '',
      doctorId: map['doctorId'] ?? '',
      visitDate: (map['visitDate'] as Timestamp).toDate(),
      symptoms: map['symptoms'] ?? '',
      diagnosis: map['diagnosis'] ?? '',
      consultationFee: (map['consultationFee'] ?? 0.0).toDouble(),
      prescriptionNotes: map['prescriptionNotes'] ?? '',
      prescriptionImageUrls: List<String>.from(map['prescriptionImageUrls'] ?? []),
      linkedBillId: map['linkedBillId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'visitId': visitId,
      'patientId': patientId,
      'doctorId': doctorId,
      'visitDate': Timestamp.fromDate(visitDate),
      'symptoms': symptoms,
      'diagnosis': diagnosis,
      'consultationFee': consultationFee,
      'prescriptionNotes': prescriptionNotes,
      'prescriptionImageUrls': prescriptionImageUrls,
      'linkedBillId': linkedBillId,
    };
  }
}
