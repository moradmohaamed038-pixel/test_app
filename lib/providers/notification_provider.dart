import 'package:flutter/material.dart';
import '../services/notifications_service.dart';

class NotificationsProvider extends ChangeNotifier {
  bool _isInitialized = false;
  List<Map<String, dynamic>> _notifications = [];

  bool get isInitialized => _isInitialized;
  List<Map<String, dynamic>> get notifications => _notifications;

  Future<void> initializeNotifications() async {
    try {
      await NotificationsService.initialize();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('❌ Error initializing notifications: $e');
    }
  }

  Future<void> showRelayNotification(String relayName, bool isOn) async {
    if (_isInitialized) {
      await NotificationsService.showRelayNotification(
        relayName: relayName,
        isOn: isOn,
      );
      _notifications.add({
        'type': 'relay',
        'message': '$relayName is now ${isOn ? 'ON' : 'OFF'}',
        'timestamp': DateTime.now(),
      });
      notifyListeners();
    }
  }

  Future<void> showDeviceOfflineNotification(String deviceName) async {
    if (_isInitialized) {
      await NotificationsService.showDeviceOfflineNotification(deviceName);
      _notifications.add({
        'type': 'device_offline',
        'message': '$deviceName is offline',
        'timestamp': DateTime.now(),
      });
      notifyListeners();
    }
  }

  Future<void> showTimerAlertNotification(String relayName) async {
    if (_isInitialized) {
      await NotificationsService.showTimerAlertNotification(relayName);
      _notifications.add({
        'type': 'timer_alert',
        'message': 'Timer for $relayName has expired',
        'timestamp': DateTime.now(),
      });
      notifyListeners();
    }
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }
}