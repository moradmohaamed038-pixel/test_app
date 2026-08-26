import 'package:flutter/material.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic>? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasProfile => _userProfile != null;

  Future<void> fetchUserProfile(String uid) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final profile = await UserService.getUserProfile(uid);
      _userProfile = profile;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveUserProfile({
    required String uid,
    required String name,
    required String email,
    required String phone,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await UserService.saveUserProfile(
        uid: uid,
        name: name,
        email: email,
        phone: phone,
      );
      _userProfile = {
        'name': name,
        'email': email,
        'phone': phone,
      };
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateUserProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await UserService.updateUserProfile(uid: uid, data: data);
      _userProfile?.addAll(data);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearProfile() {
    _userProfile = null;
    _errorMessage = null;
    notifyListeners();
  }
}