import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/device_provider.dart';
import '../providers/demo_mode_provider.dart';
import '../core/theme.dart';

class DeviceControlScreen extends StatefulWidget {
  const DeviceControlScreen({super.key});

  @override
  State<DeviceControlScreen> createState() => _DeviceControlScreenState();
}

class _DeviceControlScreenState extends State<DeviceControlScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التحكم بالجهاز'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              final device =
                  Provider.of<DeviceProvider>(context, listen: false)
                      .selectedDevice;
              if (device != null) {
                Navigator.of(context)
                    .pushNamed('/device_settings', arguments: device);
              }
            },
          ),
        ],
      ),
      body: Consumer2<DeviceProvider, DemoModeProvider>(
        builder: (context, deviceProvider, demoProvider, _) {
          final device = deviceProvider.selectedDevice ?? demoProvider.demoDevice;

          if (device == null) {
            return const Center(
              child: Text('لم يتم اختيار جهاز'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Device Info Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          device.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow('الحالة', device.isOnline ? 'متصل' : 'غير متصل'),
                        _buildInfoRow('عنوان IP', device.ipAddress),
                        _buildInfoRow('الإصدار', device.firmwareVersion),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Sensors Section
                const Text(
                  'الحساسات',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSensorCard(device.tankSensor),
                const SizedBox(height: 8),
                _buildSensorCard(device.voltageSensor),
                const SizedBox(height: 24),

                // Relays Section
                const Text(
                  'الروليهات',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: device.relays.length,
                  itemBuilder: (context, index) {
                    final relay = device.relays[index];
                    return _buildRelayCard(relay, deviceProvider, demoProvider);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorCard(dynamic sensor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sensor.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${sensor.value.toStringAsFixed(1)} ${sensor.unit}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Icon(
              sensor.id == 'tank' ? Icons.water_drop : Icons.electrical_services,
              color: AppTheme.primaryColor,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelayCard(
    dynamic relay,
    DeviceProvider deviceProvider,
    DemoModeProvider demoProvider,
  ) {
    return GestureDetector(
      onTap: () {
        if (demoProvider.isDemoMode) {
          demoProvider.toggleRelayInDemo(relay.id);
        } else {
          deviceProvider.toggleRelay(relay.id, !relay.isOn);
        }
      },
      onLongPress: () {
        Navigator.of(context)
            .pushNamed('/timer_setup', arguments: relay);
      },
      child: Card(
        color: relay.isOn ? AppTheme.primaryColor : Colors.grey.shade200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flash_on,
              color: relay.isOn ? Colors.white : Colors.grey,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              relay.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: relay.isOn ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              relay.isOn ? 'تشغيل' : 'إيقاف',
              style: TextStyle(
                fontSize: 10,
                color: relay.isOn ? Colors.white70 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}