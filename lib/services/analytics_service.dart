import 'package:firebase_database/firebase_database.dart';

class AnalyticsService {
  static final _database = FirebaseDatabase.instance;

  static Future<void> logEvent({
    required String userId,
    required String eventType,
    required Map<String, dynamic> data,
  }) async {
    try {
      final eventId = DateTime.now().millisecondsSinceEpoch.toString();
      await _database.ref('analytics/$userId/$eventType/$eventId').set({
        'timestamp': DateTime.now().toIso8601String(),
        ...data,
      });
      print('✅ Event logged: $eventType');
    } catch (e) {
      print('❌ Error logging event: $e');
    }
  }

  static Future<void> logRelayToggle({
    required String userId,
    required String deviceId,
    required String relayId,
    required bool isOn,
  }) async {
    await logEvent(
      userId: userId,
      eventType: 'relay_toggle',
      data: {
        'deviceId': deviceId,
        'relayId': relayId,
        'isOn': isOn,
      },
    );
  }

  static Future<void> logDeviceConnection({
    required String userId,
    required String deviceId,
    required bool isConnected,
  }) async {
    await logEvent(
      userId: userId,
      eventType: 'device_connection',
      data: {
        'deviceId': deviceId,
        'isConnected': isConnected,
      },
    );
  }

  static Future<void> logSensorReading({
    required String userId,
    required String deviceId,
    required String sensorId,
    required double value,
  }) async {
    await logEvent(
      userId: userId,
      eventType: 'sensor_reading',
      data: {
        'deviceId': deviceId,
        'sensorId': sensorId,
        'value': value,
      },
    );
  }

  static Future<Map<String, dynamic>?> getDeviceStats({
    required String userId,
    required String deviceId,
  }) async {
    try {
      final snapshot = await _database
          .ref('analytics/$userId')
          .orderByChild('deviceId')
          .equalTo(deviceId)
          .get();

      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      print('❌ Error getting device stats: $e');
      return null;
    }
  }
}