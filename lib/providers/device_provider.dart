import 'package:flutter/material.dart';
import '../models/esp_device_model.dart';
import '../models/relay_model.dart';
import '../services/cloud_sync_service.dart';

class DeviceProvider extends ChangeNotifier {
  List<EspDevice> _devices = [];
  EspDevice? _selectedDevice;
  bool _isLoading = false;
  String? _errorMessage;

  List<EspDevice> get devices => _devices;
  EspDevice? get selectedDevice => _selectedDevice;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void addDevice(EspDevice device) {
    _devices.add(device);
    notifyListeners();
  }

  void removeDevice(String deviceId) {
    _devices.removeWhere((device) => device.id == deviceId);
    if (_selectedDevice?.id == deviceId) {
      _selectedDevice = null;
    }
    notifyListeners();
  }

  void selectDevice(EspDevice device) {
    _selectedDevice = device;
    notifyListeners();
  }

  void updateDevice(EspDevice device) {
    final index = _devices.indexWhere((d) => d.id == device.id);
    if (index >= 0) {
      _devices[index] = device;
      if (_selectedDevice?.id == device.id) {
        _selectedDevice = device;
      }
      notifyListeners();
    }
  }

  void toggleRelay(String relayId, bool value) {
    if (_selectedDevice != null) {
      final relayIndex = _selectedDevice!.relays.indexWhere((r) => r.id == relayId);
      if (relayIndex >= 0) {
        _selectedDevice!.relays[relayIndex].isOn = value;
        _selectedDevice!.relays[relayIndex].lastToggled = DateTime.now();
        notifyListeners();
      }
    }
  }

  void setRelayTimer(String relayId, int minutes) {
    if (_selectedDevice != null) {
      final relayIndex = _selectedDevice!.relays.indexWhere((r) => r.id == relayId);
      if (relayIndex >= 0) {
        _selectedDevice!.relays[relayIndex].timerMinutes = minutes;
        notifyListeners();
      }
    }
  }

  Future<void> syncDeviceToCloud({
    required String userId,
    required EspDevice device,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await CloudSyncService.syncDevice(userId: userId, device: device);
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