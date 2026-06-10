import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart'; // Import the correct model instead of duplicating it

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppUser? _currentUser;
  bool _isLoading = true;
  String? _errorMessage;
  bool _useMock = false;

  AppUser? get currentUser => _currentUser;
  AppUser? get user => _currentUser; // Added to match usages
  bool get isLoading => _isLoading;
  bool get isAdmin => _currentUser?.isAdmin ?? false; // Uses getter from user_model.dart
  bool get isAuthenticated => _currentUser != null; // Added to match splash_view.dart
  String? get errorMessage => _errorMessage; // Added to match login_view.dart
  bool get useMock => _useMock; // Added to match login_view.dart

  void setUseMock(bool value) {
    _useMock = value;
    _errorMessage = null;
    notifyListeners();
  }

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    _auth.authStateChanges().listen((User? user) async {
      _isLoading = true;
      notifyListeners();
      if (user != null) {
        await _fetchUserDetails(user.uid);
      } else {
        _currentUser = null;
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> _fetchUserDetails(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _currentUser = AppUser.fromMap(doc.data()!, uid);
      }
    } catch (e) {
      debugPrint("Error fetching user details: $e");
    }
  }

  Future<bool> signIn(String email, String password) async {
    return signInWithEmailAndPassword(email, password);
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (_useMock) {
        final role = email.toLowerCase().contains('admin') ? 'admin' : 'staff';
        await signInAsMockUser(role);
        return _currentUser != null;
      }

      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        await _fetchUserDetails(credential.user!.uid);
        if (_currentUser == null) {
          _errorMessage = "User record not found in system.";
          await _auth.signOut();
          _isLoading = false;
          notifyListeners();
          return false;
        }
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? "Authentication failed";
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signInAsMockUser(String role) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _auth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? "Anonymous authentication failed";
      _currentUser = null;
      _isLoading = false;
      notifyListeners();
      return;
    } catch (e) {
      _errorMessage = e.toString();
      _currentUser = null;
      _isLoading = false;
      notifyListeners();
      return;
    }

    await Future.delayed(const Duration(milliseconds: 500));
    final normalizedRole = role.toLowerCase() == 'admin' ? 'admin' : 'staff';
    _currentUser = AppUser(
      uid: 'mock_uid_${role.toLowerCase()}',
      customId: role.toLowerCase() == 'admin' ? 'U1' : 'U2',
      email: '${role.toLowerCase()}@shrihitham.com',
      role: normalizedRole,
      name: 'Mock ${normalizedRole[0].toUpperCase()}${normalizedRole.substring(1)} User',
      createdAt: DateTime.now(),
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }
}
