import 'dart:async';
import 'package:flutter/material.dart';
import '../models/patient_model.dart';
import '../services/patient_firestore_service.dart';

class PatientProvider extends ChangeNotifier {
  final PatientFirestoreService _firestoreService;

  List<PatientModel> _patients = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  StreamSubscription<List<PatientModel>>? _patientsSubscription;

  List<PatientModel> get patients => _patients;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  PatientProvider({PatientFirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? PatientFirestoreService() {
    _listenToPatients();
  }

  void _listenToPatients() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _patientsSubscription?.cancel();
    _patientsSubscription = _firestoreService.getPatients().listen(
      (patientList) {
        _patients = patientList;
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

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Real-time filtering based on query string
  List<PatientModel> get filteredPatients {
    if (_searchQuery.isEmpty) {
      return _patients;
    }
    final query = _searchQuery.toLowerCase();
    return _patients.where((patient) {
      return patient.patientId.toLowerCase().contains(query) ||
          patient.name.toLowerCase().contains(query) ||
          patient.phone.contains(query);
    }).toList();
  }

  // Duplicate Check logic: Name & Phone must be unique in active database
  Future<bool> checkDuplicate(String name, String phone) async {
    final normalizedName = name.trim().toLowerCase();
    final normalizedPhone = phone.trim();
    return _patients.any((patient) =>
        patient.name.trim().toLowerCase() == normalizedName &&
        patient.phone.trim() == normalizedPhone);
  }

  Future<String?> addPatient({
    required String name,
    required int age,
    required String gender,
    required String phone,
    required DateTime dateOfBirth,
    required String address,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Check duplicate
      final isDuplicate = await checkDuplicate(name, phone);
      if (isDuplicate) {
        _error = 'A patient with the same name and phone number already exists.';
        _isLoading = false;
        notifyListeners();
        return null;
      }

      final newPatient = PatientModel(
        id: '', // Will be assigned inside PatientFirestoreService via IdService
        patientId: '', // Will be assigned inside PatientFirestoreService via IdService
        name: name.trim(),
        age: age,
        gender: gender,
        phone: phone.trim(),
        dateOfBirth: dateOfBirth,
        address: address.trim(),
        registrationDate: DateTime.now(),
      );

      final patientId = await _firestoreService.addPatient(newPatient);
      _isLoading = false;
      notifyListeners();
      return patientId;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> updatePatient(PatientModel patient) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Validate name and phone duplication on edit (if changed)
      final existingPatient = _patients.firstWhere((p) => p.id == patient.id);
      if (existingPatient.name != patient.name || existingPatient.phone != patient.phone) {
        final isDuplicate = await checkDuplicate(patient.name, patient.phone);
        if (isDuplicate) {
          _error = 'A patient with the same name and phone number already exists.';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      }

      await _firestoreService.updatePatient(patient);
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

  Future<bool> deletePatient(String patientId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestoreService.deletePatient(patientId);
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

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _patientsSubscription?.cancel();
    super.dispose();
  }
}
