import 'package:web_socket_channel/web_socket_channel.dart';

class LocalConnectionService {
  WebSocketChannel? _channel;
  String? _deviceIp;

  Future<bool> connect(String deviceIp) async {
    try {
      _deviceIp = deviceIp;
      final url = Uri.parse('ws://$deviceIp:8080');
      _channel = WebSocketChannel.connect(url);
      
      await _channel!.ready;
      print('✅ Connected to device at $deviceIp');
      return true;
    } catch (e) {
      print('❌ Connection error: $e');
      return false;
    }
  }

  bool get isConnected => _channel != null && _deviceIp != null;

  Stream<dynamic> get messages => _channel?.stream ?? const Stream.empty();

  void sendCommand(Map<String, dynamic> command) {
    try {
      _channel?.sink.add(Uri(scheme: 'json', path: command.toString()).toString());
      print('✅ Command sent: $command');
    } catch (e) {
      print('❌ Error sending command: $e');
    }
  }

  void toggleRelay(String relayId, bool value) {
    sendCommand({
      'action': 'toggleRelay',
      'relayId': relayId,
      'value': value,
    });
  }

  void setTimer(String relayId, int minutes) {
    sendCommand({
      'action': 'setTimer',
      'relayId': relayId,
      'minutes': minutes,
    });
  }

  Future<void> disconnect() async {
    try {
      await _channel?.sink.close();
      _channel = null;
      _deviceIp = null;
      print('✅ Disconnected from device');
    } catch (e) {
      print('❌ Disconnect error: $e');
    }
  }
}