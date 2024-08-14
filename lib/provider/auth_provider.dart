import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get user => _auth.currentUser;
  bool get isAuthenticated => user != null;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> register(String name, String email, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      _errorMessage = 'Passwords do not match';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Create user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Store user details in Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'name': name,
        'email': email,
      });

    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _auth.signOut();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
