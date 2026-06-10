import 'package:cloud_firestore/cloud_firestore.dart';

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
}

class PrescriptionModel {
  final String id; // Firestore auto-ID
  final String visitId; // references VisitModel.id
  final String patientId; // references PatientModel.id
  final String? billId; // references PatientBillModel.id
  final DateTime date;
  final List<PrescribedMedicine> medicines;

  PrescriptionModel({
    required this.id,
    required this.visitId,
    required this.patientId,
    this.billId,
    required this.date,
    required this.medicines,
  });

  // Convert Map to PrescriptionModel
  factory PrescriptionModel.fromMap(Map<String, dynamic> map, String documentId) {
    final list = map['medicines'] as List? ?? [];
    final prescribedList = list.map((item) => PrescribedMedicine.fromMap(Map<String, dynamic>.from(item))).toList();

    return PrescriptionModel(
      id: documentId,
      visitId: map['visitId'] ?? '',
      patientId: map['patientId'] ?? '',
      billId: map['billId'],
      date: map['date'] != null 
          ? (map['date'] as Timestamp).toDate() 
          : DateTime.now(),
      medicines: prescribedList,
    );
  }

  // Convert PrescriptionModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'visitId': visitId,
      'patientId': patientId,
      'billId': billId,
      'date': Timestamp.fromDate(date),
      'medicines': medicines.map((med) => med.toMap()).toList(),
    };
  }

  PrescriptionModel copyWith({
    String? id,
    String? visitId,
    String? patientId,
    String? billId,
    DateTime? date,
    List<PrescribedMedicine>? medicines,
  }) {
    return PrescriptionModel(
      id: id ?? this.id,
      visitId: visitId ?? this.visitId,
      patientId: patientId ?? this.patientId,
      billId: billId ?? this.billId,
      date: date ?? this.date,
      medicines: medicines ?? this.medicines,
    );
  }
}
