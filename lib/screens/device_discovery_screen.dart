import 'package:flutter/material.dart';
import '../services/device_discovery_service.dart';
import '../core/theme.dart';

class DeviceDiscoveryScreen extends StatefulWidget {
  const DeviceDiscoveryScreen({super.key});

  @override
  State<DeviceDiscoveryScreen> createState() => _DeviceDiscoveryScreenState();
}

class _DeviceDiscoveryScreenState extends State<DeviceDiscoveryScreen> {
  List<Map<String, String>> _devices = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _discoverDevices();
  }

  Future<void> _discoverDevices() async {
    setState(() {
      _isSearching = true;
    });

    try {
      final devices = await DeviceDiscoveryService.discoverDevices();
      setState(() {
        _devices = devices;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في البحث: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اكتشاف الأجهزة'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _isSearching ? null : _discoverDevices,
              icon: const Icon(Icons.search),
              label: const Text('بحث عن الأجهزة'),
            ),
          ),
          Expanded(
            child: _isSearching
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _devices.isEmpty
                    ? Center(
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
                              'لم يتم العثور على أجهزة',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _devices.length,
                        itemBuilder: (context, index) {
                          final device = _devices[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.router),
                              title: Text(device['name'] ?? 'جهاز غير معروف'),
                              subtitle: Text(
                                device['target'] ?? 'IP: غير معروف',
                              ),
                              trailing: Icon(
                                Icons.arrow_forward,
                                color: AppTheme.primaryColor,
                              ),
                              onTap: () {
                                Navigator.of(context).pushReplacementNamed(
                                  '/devices_list',
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}