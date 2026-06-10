import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseBillItem {
  final String medicineId; // references MedicineModel.id
  final String name;
  final int quantity;
  final double unitCost;
  final double totalCost;

  PurchaseBillItem({
    required this.medicineId,
    required this.name,
    required this.quantity,
    required this.unitCost,
    required this.totalCost,
  });

  factory PurchaseBillItem.fromMap(Map<String, dynamic> map) {
    return PurchaseBillItem(
      medicineId: map['medicineId'] ?? '',
      name: map['name'] ?? '',
      quantity: map['quantity'] as int? ?? 0,
      unitCost: (map['unitCost'] as num?)?.toDouble() ?? 0.0,
      totalCost: (map['totalCost'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'medicineId': medicineId,
      'name': name,
      'quantity': quantity,
      'unitCost': unitCost,
      'totalCost': totalCost,
    };
  }
}

class PurchaseBillModel {
  final String id; // e.g. P1
  final String supplierId; // references SupplierModel.id
  final DateTime billDate;
  final double totalAmount;
  final String paymentStatus; // 'paid', 'pending'
  final List<PurchaseBillItem> items;

  PurchaseBillModel({
    required this.id,
    required this.supplierId,
    required this.billDate,
    required this.totalAmount,
    required this.paymentStatus,
    required this.items,
  });

  // Convert Map to PurchaseBillModel
  factory PurchaseBillModel.fromMap(Map<String, dynamic> map, String documentId) {
    final list = map['items'] as List? ?? [];
    final itemList = list.map((item) => PurchaseBillItem.fromMap(Map<String, dynamic>.from(item))).toList();

    return PurchaseBillModel(
      id: documentId,
      supplierId: map['supplierId'] ?? '',
      billDate: map['billDate'] != null 
          ? (map['billDate'] as Timestamp).toDate() 
          : DateTime.now(),
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      paymentStatus: map['paymentStatus'] ?? 'pending',
      items: itemList,
    );
  }

  // Convert PurchaseBillModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'supplierId': supplierId,
      'billDate': Timestamp.fromDate(billDate),
      'totalAmount': totalAmount,
      'paymentStatus': paymentStatus,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  PurchaseBillModel copyWith({
    String? id,
    String? supplierId,
    DateTime? billDate,
    double? totalAmount,
    String? paymentStatus,
    List<PurchaseBillItem>? items,
  }) {
    return PurchaseBillModel(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      billDate: billDate ?? this.billDate,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      items: items ?? this.items,
    );
  }
}
