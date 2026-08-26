import 'package:multicast_dns/multicast_dns.dart';

class DeviceDiscoveryService {
  static const String serviceType = '_morad._tcp';
  static const String serviceName = 'morad';

  static Future<List<Map<String, String>>> discoverDevices({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final List<Map<String, String>> devices = [];

    try {
      final MDnsClient mdnsClient = MDnsClient();
      await mdnsClient.start();

      await mdnsClient
          .lookup<SrvResourceRecord>(
            ResourceRecordQuery.service(serviceType),
            duration: timeout,
          )
          .listen((resourceRecord) {
            if (resourceRecord is SrvResourceRecord) {
              devices.add({
                'name': resourceRecord.name,
                'target': resourceRecord.target,
              });
            }
          })
          .asFuture();

      mdnsClient.stop();
      print('✅ Discovered ${devices.length} device(s)');
      return devices;
    } catch (e) {
      print('❌ Device discovery error: $e');
      return [];
    }
  }

  static Future<String?> resolveDeviceIp(String deviceName) async {
    try {
      final MDnsClient mdnsClient = MDnsClient();
      await mdnsClient.start();

      var addresses = await mdnsClient
          .lookup<A>(
            ResourceRecordQuery.addressRecord(deviceName),
            duration: const Duration(seconds: 3),
          )
          .toList();

      mdnsClient.stop();

      if (addresses.isNotEmpty) {
        return addresses.first.address.address;
      }
      return null;
    } catch (e) {
      print('❌ Error resolving device IP: $e');
      return null;
    }
  }
}