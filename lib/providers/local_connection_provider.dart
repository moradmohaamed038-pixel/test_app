import 'package:flutter/material.dart';
import '../services/local_connection_service.dart';

class LocalConnectionProvider extends ChangeNotifier {
  final LocalConnectionService _service = LocalConnectionService();
  bool _isConnected = false;
  bool _isConnecting = false;
  String? _connectedDeviceIp;
  String? _errorMessage;

  bool get isConnected => _isConnected;
  bool get isConnecting => _isConnecting;
  String? get connectedDeviceIp => _connectedDeviceIp;
  String? get errorMessage => _errorMessage;

  Future<bool> connectToDevice(String deviceIp) async {
    _isConnecting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _service.connect(deviceIp);
      if (success) {
        _isConnected = true;
        _connectedDeviceIp = deviceIp;
        _isConnecting = false;
        notifyListeners();
        return true;
      }
      _errorMessage = 'Connection failed';
      _isConnecting = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isConnecting = false;
      notifyListeners();
      return false;
    }
  }

  void toggleRelay(String relayId, bool value) {
    if (_isConnected) {
      _service.toggleRelay(relayId, value);
    }
  }

  void setTimer(String relayId, int minutes) {
    if (_isConnected) {
      _service.setTimer(relayId, minutes);
    }
  }

  Future<void> disconnect() async {
    try {
      await _service.disconnect();
      _isConnected = false;
      _connectedDeviceIp = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Stream<dynamic> get messages => _service.messages;
}