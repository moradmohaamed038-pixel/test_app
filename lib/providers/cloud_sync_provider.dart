import 'package:flutter/material.dart';
import '../models/esp_device_model.dart';
import '../models/relay_model.dart';
import '../models/command_model.dart';
import '../services/cloud_sync_service.dart';

class CloudSyncProvider extends ChangeNotifier {
  bool _isSyncing = false;
  String? _errorMessage;
  DateTime? _lastSyncTime;

  bool get isSyncing => _isSyncing;
  String? get errorMessage => _errorMessage;
  DateTime? get lastSyncTime => _lastSyncTime;

  Future<void> syncDevice({
    required String userId,
    required EspDevice device,
  }) async {
    _isSyncing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await CloudSyncService.syncDevice(userId: userId, device: device);
      _lastSyncTime = DateTime.now();
      _isSyncing = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<void> syncRelayState({
    required String userId,
    required String deviceId,
    required Relay relay,
  }) async {
    _isSyncing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await CloudSyncService.syncRelayState(
        userId: userId,
        deviceId: deviceId,
        relay: relay,
      );
      _lastSyncTime = DateTime.now();
      _isSyncing = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<void> executeCommand({
    required String userId,
    required DeviceCommand command,
  }) async {
    _isSyncing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await CloudSyncService.executeCommand(
        userId: userId,
        command: command,
      );
      _lastSyncTime = DateTime.now();
      _isSyncing = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isSyncing = false;
      notifyListeners();
    }
  }

  Stream<dynamic> getDeviceUpdates(String userId, String deviceId) {
    return CloudSyncService.getDeviceUpdates(userId, deviceId);
  }
}