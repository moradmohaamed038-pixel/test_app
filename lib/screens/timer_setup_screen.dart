import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/relay_model.dart';
import '../providers/device_provider.dart';
import '../providers/demo_mode_provider.dart';
import '../core/theme.dart';

class TimerSetupScreen extends StatefulWidget {
  final Relay relay;

  const TimerSetupScreen({super.key, required this.relay});

  @override
  State<TimerSetupScreen> createState() => _TimerSetupScreenState();
}

class _TimerSetupScreenState extends State<TimerSetupScreen> {
  late int _selectedMinutes;

  @override
  void initState() {
    super.initState();
    _selectedMinutes = widget.relay.timerMinutes > 0 ? widget.relay.timerMinutes : 10;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ضبط المؤقت'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Consumer2<DeviceProvider, DemoModeProvider>(
          builder: (context, deviceProvider, demoProvider, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'المدة الزمنية',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryColor.withOpacity(0.1),
                  ),
                  child: Text(
                    '$_selectedMinutes',
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text('دقيقة'),
                const SizedBox(height: 48),
                Slider(
                  value: _selectedMinutes.toDouble(),
                  min: 1,
                  max: 120,
                  divisions: 119,
                  label: '$_selectedMinutes',
                  onChanged: (value) {
                    setState(() {
                      _selectedMinutes = value.toInt();
                    });
                  },
                ),
                const SizedBox(height: 48),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('إلغاء'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (demoProvider.isDemoMode) {
                            demoProvider.setRelayTimerInDemo(
                              widget.relay.id,
                              _selectedMinutes,
                            );
                          } else {
                            deviceProvider.setRelayTimer(
                              widget.relay.id,
                              _selectedMinutes,
                            );
                          }
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'تم ضبط المؤقت على $_selectedMinutes دقيقة',
                              ),
                            ),
                          );
                        },
                        child: const Text('تطبيق'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}