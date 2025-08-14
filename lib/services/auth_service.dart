import 'dart:async';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthResult {
  final bool success;
  final String? errorMessage;
  final User? user;
  final String? token;

  AuthResult({
    required this.success,
    this.errorMessage,
    this.user,
    this.token,
  });
}

class AuthService extends ChangeNotifier {
  User? _currentUser;
  String? _token;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _token != null;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Mock signup method
  Future<AuthResult> signUp({
    required String emailOrPhone,
    required String fullName,
    required String username,
    required String password,
  }) async {
    setLoading(true);
    
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Check for duplicate username (mock)
    if (username == 'taken') {
      setLoading(false);
      return AuthResult(
        success: false,
        errorMessage: 'Username is already taken',
      );
    }
    
    // Simulate successful signup
    final user = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: emailOrPhone.contains('@') ? emailOrPhone : '',
      phone: !emailOrPhone.contains('@') ? emailOrPhone : '',
      fullName: fullName,
      username: username,
    );
    
    _currentUser = user;
    _token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
    
    setLoading(false);
    return AuthResult(
      success: true,
      user: user,
      token: _token,
    );
  }

  // Mock login method
  Future<AuthResult> login({
    required String identifier,
    required String password,
  }) async {
    setLoading(true);
    
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Mock valid credentials
    final validCredentials = [
      {'identifier': 'user@example.com', 'password': 'password123'},
      {'identifier': '1234567890', 'password': 'phone123'},
      {'identifier': 'testuser', 'password': 'test123'},
    ];
    
    // Check if credentials match any valid pair
    final isValid = validCredentials.any((cred) => 
      cred['identifier'] == identifier && cred['password'] == password);
    
    if (!isValid) {
      setLoading(false);
      return AuthResult(
        success: false,
        errorMessage: 'Invalid credentials',
      );
    }
    
    // Simulate successful login
    final user = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: identifier.contains('@') ? identifier : '',
      phone: identifier.contains('phone') ? identifier : '',
      fullName: 'Test User',
      username: identifier.contains('@') ? 'testuser' : identifier,
    );
    
    _currentUser = user;
    _token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
    
    setLoading(false);
    return AuthResult(
      success: true,
      user: user,
      token: _token,
    );
  }

  // Mock Google sign-in
  Future<AuthResult> signInWithGoogle() async {
    setLoading(true);
    
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate successful Google sign-in
    final user = User(
      id: 'google_user_${DateTime.now().millisecondsSinceEpoch}',
      email: 'google_user@example.com',
      phone: '',
      fullName: 'Google User',
      username: 'googleuser',
    );
    
    _currentUser = user;
    _token = 'google_token_${DateTime.now().millisecondsSinceEpoch}';
    
    setLoading(false);
    return AuthResult(
      success: true,
      user: user,
      token: _token,
    );
  }

  // Logout method
  void logout() {
    _currentUser = null;
    _token = null;
    notifyListeners();
  }
}