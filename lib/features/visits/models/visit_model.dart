import 'package:cloud_firestore/cloud_firestore.dart';

class VisitModel {
  final String id;
  final String visitId;
  final String patientId;
  final DateTime visitDate;
  final String symptoms;
  final String diagnosis;
  final String doctorNotes;
  final DateTime? followUpDate;
  final DateTime createdAt;

  VisitModel({
    required this.id,
    required this.visitId,
    required this.patientId,
    required this.visitDate,
    required this.symptoms,
    required this.diagnosis,
    required this.doctorNotes,
    this.followUpDate,
    required this.createdAt,
  });

  factory VisitModel.fromMap(Map<String, dynamic> map, String documentId) {
    return VisitModel(
      id: documentId,
      visitId: map['visitId'] ?? '',
      patientId: map['patientId'] ?? '',
      visitDate: map['visitDate'] != null
          ? (map['visitDate'] as Timestamp).toDate()
          : DateTime.now(),
      symptoms: map['symptoms'] ?? '',
      diagnosis: map['diagnosis'] ?? '',
      doctorNotes: map['doctorNotes'] ?? '',
      followUpDate: map['followUpDate'] != null
          ? (map['followUpDate'] as Timestamp).toDate()
          : null,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'visitId': visitId,
      'patientId': patientId,
      'visitDate': Timestamp.fromDate(visitDate),
      'symptoms': symptoms,
      'diagnosis': diagnosis,
      'doctorNotes': doctorNotes,
      'followUpDate': followUpDate != null ? Timestamp.fromDate(followUpDate!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  VisitModel copyWith({
    String? id,
    String? visitId,
    String? patientId,
    DateTime? visitDate,
    String? symptoms,
    String? diagnosis,
    String? doctorNotes,
    DateTime? followUpDate,
    DateTime? createdAt,
  }) {
    return VisitModel(
      id: id ?? this.id,
      visitId: visitId ?? this.visitId,
      patientId: patientId ?? this.patientId,
      visitDate: visitDate ?? this.visitDate,
      symptoms: symptoms ?? this.symptoms,
      diagnosis: diagnosis ?? this.diagnosis,
      doctorNotes: doctorNotes ?? this.doctorNotes,
      followUpDate: followUpDate ?? this.followUpDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
