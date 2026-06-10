import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_collections.dart';
import '../models/prescription_model.dart';

class PrescriptionFirestoreService {
  final FirebaseFirestore _firestore;

  PrescriptionFirestoreService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Adds a new prescription with a transaction-safe sequential ID (e.g. P0001, P0002).
  ///
  /// Uses a fallback query on existing records to initialize/align the counters collection document
  /// if it does not exist yet.
  Future<String> addPrescription(PrescriptionModel prescription) async {
    try {
      // 1. Scan for highest existing prescription number as legacy fallback
      final querySnapshot = await _firestore
          .collection(FirestoreCollections.prescriptions)
          .get();

      int maxExistingCount = 0;
      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final rxIdStr = data['prescriptionId'] as String?;
        if (rxIdStr != null && rxIdStr.startsWith('P')) {
          final numericPart = int.tryParse(rxIdStr.substring(1));
          if (numericPart != null && numericPart > maxExistingCount) {
            maxExistingCount = numericPart;
          }
        }
      }

      final counterRef = _firestore
          .collection(FirestoreCollections.counters)
          .doc('prescriptions');

      // 2. Transactionally get or set the counter and write the prescription document
      final formattedId = await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(counterRef);
        int nextCount;
        if (snapshot.exists) {
          final currentCount = snapshot.data()?['count'] ?? 0;
          nextCount = currentCount + 1;
          transaction.update(counterRef, {'count': nextCount});
        } else {
          nextCount = maxExistingCount + 1;
          transaction.set(counterRef, {'count': nextCount});
        }

        final formattedIdVal = 'P${nextCount.toString().padLeft(4, '0')}';
        final docId = formattedIdVal;

        final newPrescription = prescription.copyWith(
          id: docId,
          prescriptionId: formattedIdVal,
        );

        final docRef = _firestore
            .collection(FirestoreCollections.prescriptions)
            .doc(docId);
        transaction.set(docRef, newPrescription.toMap());

        return formattedIdVal;
      });

      return formattedId;
    } on FirebaseException catch (e) {
      throw Exception('Firestore error adding prescription: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error adding prescription: $e');
    }
  }

  /// Gets a stream of prescriptions matching the specified [visitId], sorted by date descending.
  Stream<List<PrescriptionModel>> getPrescriptionsByVisit(String visitId) {
    return _firestore
        .collection(FirestoreCollections.prescriptions)
        .where('visitId', isEqualTo: visitId)
        .orderBy('prescriptionDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => PrescriptionModel.fromMap(
                  doc.data(),
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  /// Gets a stream of prescriptions matching the specified [patientId], sorted by date descending.
  Stream<List<PrescriptionModel>> getPrescriptionsByPatient(String patientId) {
    return _firestore
        .collection(FirestoreCollections.prescriptions)
        .where('patientId', isEqualTo: patientId)
        .orderBy('prescriptionDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => PrescriptionModel.fromMap(
                  doc.data(),
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  /// Deletes the prescription matching the specified [prescriptionId] document ID.
  Future<void> deletePrescription(String prescriptionId) async {
    try {
      await _firestore
          .collection(FirestoreCollections.prescriptions)
          .doc(prescriptionId)
          .delete();
    } on FirebaseException catch (e) {
      throw Exception('Firestore error deleting prescription: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting prescription: $e');
    }
  }
}
