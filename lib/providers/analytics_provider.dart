import 'package:flutter/material.dart';
import '../services/analytics_service.dart';

class AnalyticsProvider extends ChangeNotifier {
  bool _isLoading = false;
  Map<String, dynamic>? _deviceStats;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  Map<String, dynamic>? get deviceStats => _deviceStats;
  String? get errorMessage => _errorMessage;

  Future<void> logRelayToggle({
    required String userId,
    required String deviceId,
    required String relayId,
    required bool isOn,
  }) async {
    try {
      await AnalyticsService.logRelayToggle(
        userId: userId,
        deviceId: deviceId,
        relayId: relayId,
        isOn: isOn,
      );
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> logDeviceConnection({
    required String userId,
    required String deviceId,
    required bool isConnected,
  }) async {
    try {
      await AnalyticsService.logDeviceConnection(
        userId: userId,
        deviceId: deviceId,
        isConnected: isConnected,
      );
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> logSensorReading({
    required String userId,
    required String deviceId,
    required String sensorId,
    required double value,
  }) async {
    try {
      await AnalyticsService.logSensorReading(
        userId: userId,
        deviceId: deviceId,
        sensorId: sensorId,
        value: value,
      );
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchDeviceStats({
    required String userId,
    required String deviceId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final stats = await AnalyticsService.getDeviceStats(
        userId: userId,
        deviceId: deviceId,
      );
      _deviceStats = stats;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}