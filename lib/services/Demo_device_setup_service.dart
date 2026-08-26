import '../models/esp_device_model.dart';
import '../models/relay_model.dart';
import '../models/sensor_model.dart';

class DemoDeviceSetupService {
  static EspDevice createDemoDevice() {
    return EspDevice(
      id: 'demo_device_001',
      name: 'Demo Device',
      ipAddress: '192.168.1.100',
      macAddress: 'AA:BB:CC:DD:EE:FF',
      firmwareVersion: '2.0.0',
      isOnline: true,
      location: 'Demo Room',
      ownerId: 'demo_user',
      relays: List.generate(12, (i) {
        return Relay(
          id: 'R${i + 1}',
          name: 'Relay ${i + 1}',
          isOn: false,
          gpio: 32 + i,
        );
      }),
      tankSensor: Sensor(
        id: 'tank',
        name: 'Tank Level',
        value: 75.0,
        unit: '%',
        minValue: 0.0,
        maxValue: 100.0,
      ),
      voltageSensor: Sensor(
        id: 'voltage',
        name: 'Voltage',
        value: 220.0,
        unit: 'V',
        minValue: 200.0,
        maxValue: 240.0,
      ),
    );
  }

  static void simulateRelayToggle(EspDevice device, String relayId) {
    final relayIndex = int.parse(relayId.replaceAll('R', '')) - 1;
    if (relayIndex >= 0 && relayIndex < device.relays.length) {
      device.relays[relayIndex].isOn = !device.relays[relayIndex].isOn;
      print('✅ Demo: Relay $relayId toggled to ${device.relays[relayIndex].isOn}');
    }
  }

  static void simulateSensorReading(EspDevice device) {
    device.tankSensor.updateValue(50.0 + (DateTime.now().millisecond % 50).toDouble());
    device.voltageSensor.updateValue(215.0 + (DateTime.now().millisecond % 25).toDouble());
    print('✅ Demo: Sensor readings updated');
  }
}