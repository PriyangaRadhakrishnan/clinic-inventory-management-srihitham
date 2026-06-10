import 'package:cloud_firestore/cloud_firestore.dart';

enum MedicineUnit {
  g,
  ml,
  tablet,
  capsule,
  bottle,
  strip,
  box
}

extension MedicineUnitExtension on MedicineUnit {
  String get name {
    return toString().split('.').last;
  }
}

MedicineUnit _unitFromString(String unit) {
  switch (unit) {
    case 'g': return MedicineUnit.g;
    case 'ml': return MedicineUnit.ml;
    case 'tablet': return MedicineUnit.tablet;
    case 'capsule': return MedicineUnit.capsule;
    case 'bottle': return MedicineUnit.bottle;
    case 'strip': return MedicineUnit.strip;
    case 'box': return MedicineUnit.box;
    default: throw ArgumentError('Invalid unit: $unit');
  }
}

class MedicineModel {
  final String id;
  final String name;
  final String category;
  final double quantity;
  final MedicineUnit unit;
  final double purchasePrice;
  final double sellingPrice;
  final double lowStockThreshold;
  final String batchNumber;
  final DateTime expiryDate;
  final String barcode;
  final String supplierId;
  final String supplierName;
  final DateTime lastUpdatedDate;

  MedicineModel({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.lowStockThreshold,
    required this.batchNumber,
    required this.expiryDate,
    required this.barcode,
    required this.supplierId,
    required this.supplierName,
    required this.lastUpdatedDate,
  });

  factory MedicineModel.fromMap(Map<String, dynamic> map, String documentId) {
    return MedicineModel(
      id: documentId,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      unit: _unitFromString(map['unit'] ?? 'tablet'),
      purchasePrice: (map['purchasePrice'] ?? 0.0).toDouble(),
      sellingPrice: (map['sellingPrice'] ?? 0.0).toDouble(),
      lowStockThreshold: (map['lowStockThreshold'] ?? 0.0).toDouble(),
      batchNumber: map['batchNumber'] ?? '',
      expiryDate: (map['expiryDate'] as Timestamp).toDate(),
      barcode: map['barcode'] ?? '',
      supplierId: map['supplierId'] ?? '',
      supplierName: map['supplierName'] ?? '',
      lastUpdatedDate: (map['lastUpdatedDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'quantity': quantity,
      'unit': unit.name,
      'purchasePrice': purchasePrice,
      'sellingPrice': sellingPrice,
      'lowStockThreshold': lowStockThreshold,
      'batchNumber': batchNumber,
      'expiryDate': Timestamp.fromDate(expiryDate),
      'barcode': barcode,
      'supplierId': supplierId,
      'supplierName': supplierName,
      'lastUpdatedDate': Timestamp.fromDate(lastUpdatedDate),
    };
  }
}
