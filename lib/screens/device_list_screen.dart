import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/device_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/demo_mode_provider.dart';
import '../models/esp_device_model.dart';
import '../core/theme.dart';

class DevicesListScreen extends StatefulWidget {
  const DevicesListScreen({super.key});

  @override
  State<DevicesListScreen> createState() => _DevicesListScreenState();
}

class _DevicesListScreenState extends State<DevicesListScreen> {
  @override
  void initState() {
    super.initState();
    _initializeDevices();
  }

  void _initializeDevices() {
    final demoProvider = Provider.of<DemoModeProvider>(context, listen: false);
    if (demoProvider.isDemoMode && demoProvider.demoDevice != null) {
      // Demo mode already initialized
      final deviceProvider =
          Provider.of<DeviceProvider>(context, listen: false);
      deviceProvider.addDevice(demoProvider.demoDevice!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أجهزتي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Consumer2<DeviceProvider, DemoModeProvider>(
        builder: (context, deviceProvider, demoProvider, _) {
          final devices = demoProvider.isDemoMode && demoProvider.demoDevice != null
              ? [demoProvider.demoDevice!]
              : deviceProvider.devices;

          if (devices.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.devices,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد أجهزة',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/device_discovery');
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة جهاز'),
                  ),
                ],
              );
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    deviceProvider.selectDevice(device);
                    Navigator.of(context).pushNamed('/device_control');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    device.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    device.location,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: device.isOnline
                                    ? AppTheme.successColor.withOpacity(0.2)
                                    : Colors.grey.withOpacity(0.2),
                              ),
                              child: Icon(
                                Icons.device_hub,
                                color: device.isOnline
                                    ? AppTheme.successColor
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              device.isOnline ? 'متصل' : 'غير متصل',
                              style: TextStyle(
                                fontSize: 12,
                                color: device.isOnline
                                    ? AppTheme.successColor
                                    : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              device.ipAddress,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed('/device_discovery');
        },
        icon: const Icon(Icons.add),
        label: const Text('جهاز جديد'),
      ),
    );
  }
}