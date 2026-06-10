import 'package:cloud_firestore/cloud_firestore.dart';

class StockHistoryModel {
  final String id; // Firestore auto ID
  final String medicineId; // references MedicineModel.id
  final String medicineName;
  final int changeQuantity; // negative for stock outs (sales), positive for stock ins (purchases/returns)
  final String type; // 'purchase', 'sale', 'adjustment', 'expiry'
  final String? referenceId; // e.g., purchaseBillId or patientBillId
  final String? patientId; // references PatientModel.id (optional)
  final String? visitId; // references VisitModel.id (optional)
  final String? billId; // references PatientBillModel.id (optional)
  final String updatedBy; // references AppUser.uid (who performed adjustment)
  final DateTime date;

  StockHistoryModel({
    required this.id,
    required this.medicineId,
    required this.medicineName,
    required this.changeQuantity,
    required this.type,
    this.referenceId,
    this.patientId,
    this.visitId,
    this.billId,
    required this.updatedBy,
    required this.date,
  });

  // Convert Map to StockHistoryModel
  factory StockHistoryModel.fromMap(Map<String, dynamic> map, String documentId) {
    return StockHistoryModel(
      id: documentId,
      medicineId: map['medicineId'] ?? '',
      medicineName: map['medicineName'] ?? '',
      changeQuantity: map['changeQuantity'] as int? ?? 0,
      type: map['type'] ?? 'adjustment',
      referenceId: map['referenceId'],
      patientId: map['patientId'],
      visitId: map['visitId'],
      billId: map['billId'],
      updatedBy: map['updatedBy'] ?? '',
      date: map['date'] != null 
          ? (map['date'] as Timestamp).toDate() 
          : DateTime.now(),
    );
  }

  // Convert StockHistoryModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicineId': medicineId,
      'medicineName': medicineName,
      'changeQuantity': changeQuantity,
      'type': type,
      'referenceId': referenceId,
      'patientId': patientId,
      'visitId': visitId,
      'billId': billId,
      'updatedBy': updatedBy,
      'date': Timestamp.fromDate(date),
    };
  }
}
