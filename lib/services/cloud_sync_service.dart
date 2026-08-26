import 'package:firebase_database/firebase_database.dart';
import '../models/esp_device_model.dart';
import '../models/relay_model.dart';
import '../models/command_model.dart';

class CloudSyncService {
  static final _database = FirebaseDatabase.instance;

  static Future<void> syncDevice({
    required String userId,
    required EspDevice device,
  }) async {
    try {
      await _database.ref('devices/$userId/${device.id}').set({
        'id': device.id,
        'name': device.name,
        'ipAddress': device.ipAddress,
        'macAddress': device.macAddress,
        'firmwareVersion': device.firmwareVersion,
        'isOnline': device.isOnline,
        'lastSeen': device.lastSeen.toIso8601String(),
        'location': device.location,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      print('✅ Device synced to cloud');
    } catch (e) {
      print('❌ Error syncing device: $e');
    }
  }

  static Future<void> syncRelayState({
    required String userId,
    required String deviceId,
    required Relay relay,
  }) async {
    try {
      await _database
          .ref('devices/$userId/$deviceId/relays/${relay.id}')
          .set({
        'id': relay.id,
        'name': relay.name,
        'isOn': relay.isOn,
        'gpio': relay.gpio,
        'timerMinutes': relay.timerMinutes,
        'hasSchedule': relay.hasSchedule,
        'lastToggled': relay.lastToggled?.toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
      print('✅ Relay state synced');
    } catch (e) {
      print('❌ Error syncing relay: $e');
    }
  }

  static Future<void> executeCommand({
    required String userId,
    required DeviceCommand command,
  }) async {
    try {
      await _database.ref('commands/$userId/${command.id}').set({
        'id': command.id,
        'deviceId': command.deviceId,
        'relayId': command.relayId,
        'type': command.type.toString(),
        'value': command.value,
        'timestamp': command.timestamp.toIso8601String(),
        'status': 'pending',
      });
      print('✅ Command executed: ${command.type}');
    } catch (e) {
      print('❌ Error executing command: $e');
    }
  }

  static Stream<DatabaseEvent> getDeviceUpdates(
    String userId,
    String deviceId,
  ) {
    return _database.ref('devices/$userId/$deviceId').onValue;
  }

  static Stream<DatabaseEvent> getRelayUpdates(
    String userId,
    String deviceId,
    String relayId,
  ) {
    return _database
        .ref('devices/$userId/$deviceId/relays/$relayId')
        .onValue;
  }
}