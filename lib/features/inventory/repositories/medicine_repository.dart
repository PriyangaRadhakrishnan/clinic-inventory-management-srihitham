import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medicine_model.dart';

class MedicineRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addMedicine(MedicineModel medicine) async {
    await _firestore.collection('medicines').add(medicine.toMap());
  }

  Future<void> updateMedicine(MedicineModel medicine) async {
    await _firestore.collection('medicines').doc(medicine.id).update(medicine.toMap());
  }

  Future<void> deleteMedicine(String id) async {
    await _firestore.collection('medicines').doc(id).delete();
  }

  Stream<List<MedicineModel>> getMedicines() {
    return _firestore.collection('medicines').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => MedicineModel.fromMap(doc.data(), doc.id)).toList();
    });
  }
}
