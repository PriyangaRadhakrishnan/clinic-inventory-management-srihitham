import 'dart:async';
import 'package:flutter/material.dart';

import '../models/visit_model.dart';
import '../services/visit_firestore_service.dart';

class VisitProvider extends ChangeNotifier {
  final VisitFirestoreService _firestoreService;

  List<VisitModel> _visits = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<List<VisitModel>>? _visitsSubscription;

  List<VisitModel> get visits => _visits;
  bool get isLoading => _isLoading;
  String? get error => _error;

  VisitProvider({VisitFirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? VisitFirestoreService();

  Future<String?> addVisit(VisitModel visit) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final visitId = await _firestoreService.addVisit(visit);
      _isLoading = false;
      notifyListeners();
      return visitId;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void loadVisitsByPatient(String patientId) {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _visitsSubscription?.cancel();
    _visitsSubscription = _firestoreService.getVisitsByPatient(patientId).listen(
      (visitList) {
        _visits = visitList;
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

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _visitsSubscription?.cancel();
    super.dispose();
  }
}
