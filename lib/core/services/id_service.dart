import 'package:cloud_firestore/cloud_firestore.dart';

class IdService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> generateId(String collectionName, String prefix) async {
    final counterRef = _firestore.collection('counters').doc(collectionName);

    return await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(counterRef);

      int newCount = 1;
      if (snapshot.exists) {
        newCount = (snapshot.data()?['count'] ?? 0) + 1;
        transaction.update(counterRef, {'count': newCount});
      } else {
        transaction.set(counterRef, {'count': newCount});
      }

      // Format: PREFIX + YYYY + Count (e.g. SH20250001 for patients, or just PREFIX+Count e.g. V1)
      if (prefix == 'SH') {
        const year = 2025;
        final paddedCount = newCount.toString().padLeft(4, '0');
        return '$prefix$year$paddedCount';
      } else {
        return '$prefix$newCount';
      }
    });
  }

  Future<String> generatePatientId() => generateId('patients', 'SH');
  Future<String> generateVisitId() => generateId('visits', 'V');
  Future<String> generateBillId() => generateId('patient_bills', 'SHB');
  Future<String> generatePurchaseId() => generateId('purchase_bills', 'P');
  Future<String> generateSupplierId() => generateId('suppliers', 'SUP');
  Future<String> generateUserId() => generateId('users', 'U');

  Future<String> generateNextId(String collectionName) async {
    switch (collectionName) {
      case 'patients':
        return generatePatientId();
      case 'visits':
        return generateVisitId();
      case 'patient_bills':
        return generateBillId();
      case 'purchase_bills':
        return generatePurchaseId();
      case 'suppliers':
        return generateSupplierId();
      case 'users':
        return generateUserId();
      default:
        throw ArgumentError('Unknown collection: $collectionName');
    }
  }
}
