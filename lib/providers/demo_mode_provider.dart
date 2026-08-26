import 'package:flutter/material.dart';
import '../models/esp_device_model.dart';
import '../services/demo_device_setup_service.dart';

class DemoModeProvider extends ChangeNotifier {
  EspDevice? _demoDevice;
  bool _isDemoMode = false;

  EspDevice? get demoDevice => _demoDevice;
  bool get isDemoMode => _isDemoMode;

  void initializeDemoMode() {
    _demoDevice = DemoDeviceSetupService.createDemoDevice();
    _isDemoMode = true;
    notifyListeners();
  }

  void toggleRelayInDemo(String relayId) {
    if (_demoDevice != null) {
      DemoDeviceSetupService.simulateRelayToggle(_demoDevice!, relayId);
      notifyListeners();
    }
  }

  void simulateSensorReadings() {
    if (_demoDevice != null) {
      DemoDeviceSetupService.simulateSensorReading(_demoDevice!);
      notifyListeners();
    }
  }

  void setRelayTimerInDemo(String relayId, int minutes) {
    if (_demoDevice != null) {
      final relayIndex =
          _demoDevice!.relays.indexWhere((r) => r.id == relayId);
      if (relayIndex >= 0) {
        _demoDevice!.relays[relayIndex].timerMinutes = minutes;
        notifyListeners();
      }
    }
  }

  void endDemoMode() {
    _demoDevice = null;
    _isDemoMode = false;
    notifyListeners();
  }
}