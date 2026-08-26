import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    print('✅ Notifications service initialized');
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'morad_tk_channel',
      'MORAD_TK',
      channelDescription: 'Smart Home Control Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  static Future<void> showRelayNotification({
    required String relayName,
    required bool isOn,
  }) async {
    await showNotification(
      id: DateTime.now().millisecond,
      title: 'Relay Control',
      body: '$relayName is now ${isOn ? 'ON' : 'OFF'}',
    );
  }

  static Future<void> showDeviceOfflineNotification(String deviceName) async {
    await showNotification(
      id: DateTime.now().millisecond,
      title: 'Device Offline',
      body: '$deviceName is offline',
    );
  }

  static Future<void> showTimerAlertNotification(String relayName) async {
    await showNotification(
      id: DateTime.now().millisecond,
      title: 'Timer Alert',
      body: 'Timer for $relayName has expired',
    );
  }
}