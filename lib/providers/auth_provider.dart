import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _currentUserId;
  String? _errorMessage;
  AuthMode _authMode = AuthMode.login;

  bool get isLoading => _isLoading;
  String? get currentUserId => _currentUserId;
  String? get errorMessage => _errorMessage;
  AuthMode get authMode => _authMode;
  bool get isAuthenticated => _currentUserId != null;

  void setAuthMode(AuthMode mode) {
    _authMode = mode;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> loginWithEmail(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userCredential = await AuthService.loginWithEmail(email, password);
      if (userCredential != null) {
        _currentUserId = userCredential.user?.uid;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _errorMessage = 'Login failed';
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

  Future<bool> registerWithEmail(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userCredential = await AuthService.registerWithEmail(email, password);
      if (userCredential != null) {
        _currentUserId = userCredential.user?.uid;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _errorMessage = 'Registration failed';
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

  Future<bool> loginAnonymously() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userCredential = await AuthService.loginAnonymously();
      if (userCredential != null) {
        _currentUserId = userCredential.user?.uid;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _errorMessage = 'Anonymous login failed';
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

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await AuthService.logout();
      _currentUserId = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

enum AuthMode { login, register }