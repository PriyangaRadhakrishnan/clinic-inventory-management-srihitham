import 'dart:async';
import 'package:flutter/material.dart';

import '../models/prescription_model.dart';
import '../services/prescription_firestore_service.dart';

class PrescriptionProvider extends ChangeNotifier {
  final PrescriptionFirestoreService _firestoreService;

  List<PrescriptionModel> _prescriptions = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<List<PrescriptionModel>>? _prescriptionsSubscription;

  List<PrescriptionModel> get prescriptions => _prescriptions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  PrescriptionProvider({
    PrescriptionFirestoreService? firestoreService,
  }) : _firestoreService = firestoreService ?? PrescriptionFirestoreService();

  /// Subscribes to real-time updates of prescriptions for a specific visit ID.
  void loadPrescriptionsByVisit(String visitId) {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _prescriptionsSubscription?.cancel();
    _prescriptionsSubscription =
        _firestoreService.getPrescriptionsByVisit(visitId).listen(
      (prescriptionList) {
        _prescriptions = prescriptionList;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (err) {
        _error = err.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Subscribes to real-time updates of prescriptions for a specific patient ID.
  void loadPrescriptionsByPatient(String patientId) {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _prescriptionsSubscription?.cancel();
    _prescriptionsSubscription =
        _firestoreService.getPrescriptionsByPatient(patientId).listen(
      (prescriptionList) {
        _prescriptions = prescriptionList;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (err) {
        _error = err.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Adds a new prescription and returns the generated prescription ID (e.g. P0001).
  Future<String?> addPrescription(PrescriptionModel prescription) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final prescriptionId =
          await _firestoreService.addPrescription(prescription);
      _isLoading = false;
      notifyListeners();
      return prescriptionId;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Deletes a prescription matching the specified [prescriptionId] document ID.
  Future<bool> deletePrescription(String prescriptionId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestoreService.deletePrescription(prescriptionId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Clears the current error state.
  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _prescriptionsSubscription?.cancel();
    super.dispose();
  }
}
