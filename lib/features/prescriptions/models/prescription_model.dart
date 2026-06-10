import 'package:cloud_firestore/cloud_firestore.dart';

enum PrescriptionType {
  typed,
  upload,
  camera,
}

class PrescribedMedicine {
  final String medicineId;
  final String name;
  final String dosage;
  final String duration;
  final String instruction;

  PrescribedMedicine({
    required this.medicineId,
    required this.name,
    required this.dosage,
    required this.duration,
    required this.instruction,
  });

  factory PrescribedMedicine.fromMap(Map<String, dynamic> map) {
    return PrescribedMedicine(
      medicineId: map['medicineId'] ?? '',
      name: map['name'] ?? '',
      dosage: map['dosage'] ?? '',
      duration: map['duration'] ?? '',
      instruction: map['instruction'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'medicineId': medicineId,
      'name': name,
      'dosage': dosage,
      'duration': duration,
      'instruction': instruction,
    };
  }

  PrescribedMedicine copyWith({
    String? medicineId,
    String? name,
    String? dosage,
    String? duration,
    String? instruction,
  }) {
    return PrescribedMedicine(
      medicineId: medicineId ?? this.medicineId,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      duration: duration ?? this.duration,
      instruction: instruction ?? this.instruction,
    );
  }
}

class PrescriptionModel {
  final String id;
  final String prescriptionId;
  final String patientId;
  final String visitId;
  final DateTime prescriptionDate;
  final PrescriptionType type;
  final List<PrescribedMedicine> medicines;
  final String? fileUrl;
  final String? fileType;
  final String? additionalNotes;
  final DateTime createdAt;

  PrescriptionModel({
    required this.id,
    required this.prescriptionId,
    required this.patientId,
    required this.visitId,
    required this.prescriptionDate,
    required this.type,
    required this.medicines,
    this.fileUrl,
    this.fileType,
    this.additionalNotes,
    required this.createdAt,
  });

  factory PrescriptionModel.fromMap(Map<String, dynamic> map, String documentId) {
    final list = map['medicines'] as List? ?? [];
    final medicinesList = list
        .map((item) => PrescribedMedicine.fromMap(Map<String, dynamic>.from(item)))
        .toList();

    final typeStr = map['type'] as String?;
    final typeVal = PrescriptionType.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => PrescriptionType.typed,
    );

    return PrescriptionModel(
      id: documentId,
      prescriptionId: map['prescriptionId'] ?? '',
      patientId: map['patientId'] ?? '',
      visitId: map['visitId'] ?? '',
      prescriptionDate: map['prescriptionDate'] != null
          ? (map['prescriptionDate'] as Timestamp).toDate()
          : DateTime.now(),
      type: typeVal,
      medicines: medicinesList,
      fileUrl: map['fileUrl'] as String?,
      fileType: map['fileType'] as String?,
      additionalNotes: map['additionalNotes'] as String?,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'prescriptionId': prescriptionId,
      'patientId': patientId,
      'visitId': visitId,
      'prescriptionDate': Timestamp.fromDate(prescriptionDate),
      'type': type.name,
      'medicines': medicines.map((med) => med.toMap()).toList(),
      'fileUrl': fileUrl,
      'fileType': fileType,
      'additionalNotes': additionalNotes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  PrescriptionModel copyWith({
    String? id,
    String? prescriptionId,
    String? patientId,
    String? visitId,
    DateTime? prescriptionDate,
    PrescriptionType? type,
    List<PrescribedMedicine>? medicines,
    String? fileUrl,
    String? fileType,
    String? additionalNotes,
    DateTime? createdAt,
  }) {
    return PrescriptionModel(
      id: id ?? this.id,
      prescriptionId: prescriptionId ?? this.prescriptionId,
      patientId: patientId ?? this.patientId,
      visitId: visitId ?? this.visitId,
      prescriptionDate: prescriptionDate ?? this.prescriptionDate,
      type: type ?? this.type,
      medicines: medicines ?? this.medicines,
      fileUrl: fileUrl ?? this.fileUrl,
      fileType: fileType ?? this.fileType,
      additionalNotes: additionalNotes ?? this.additionalNotes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
