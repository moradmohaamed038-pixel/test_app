import 'package:flutter/material.dart';
import '../models/relay_model.dart';
import '../models/schedule_model.dart';
import '../core/theme.dart';

class ScheduleSetupScreen extends StatefulWidget {
  final Relay relay;

  const ScheduleSetupScreen({super.key, required this.relay});

  @override
  State<ScheduleSetupScreen> createState() => _ScheduleSetupScreenState();
}

class _ScheduleSetupScreenState extends State<ScheduleSetupScreen> {
  late ScheduleType _selectedType;
  late TimeOfDay _selectedTime;
  late Duration _selectedDuration;
  late List<int> _selectedDays;

  @override
  void initState() {
    super.initState();
    _selectedType = ScheduleType.daily;
    _selectedTime = const TimeOfDay(hour: 10, minute: 0);
    _selectedDuration = const Duration(hours: 1);
    _selectedDays = [1, 2, 3, 4, 5];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('جدولة الروليه'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'نوع الجدولة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildScheduleTypeSelector(),
            const SizedBox(height: 32),
            const Text(
              'الوقت',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );
                if (time != null) {
                  setState(() {
                    _selectedTime = time;
                  });
                }
              },
              icon: const Icon(Icons.access_time),
              label: Text(_selectedTime.format(context)),
            ),
            const SizedBox(height: 32),
            const Text(
              'المدة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Slider(
              value: _selectedDuration.inMinutes.toDouble(),
              min: 5,
              max: 240,
              divisions: 47,
              label: '${_selectedDuration.inMinutes} دقيقة',
              onChanged: (value) {
                setState(() {
                  _selectedDuration = Duration(minutes: value.toInt());
                });
              },
            ),
            Text(
              'المدة: ${_selectedDuration.inMinutes} دقيقة',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (_selectedType == ScheduleType.weekly) ...[
              const SizedBox(height: 32),
              const Text(
                'أيام الأسبوع',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _buildDaysSelector(),
            ],
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
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'تم حفظ الجدولة: ${_selectedType.toString().split('.').last}',
                          ),
                        ),
                      );
                    },
                    child: const Text('حفظ'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleTypeSelector() {
    return Row(
      children: [
        _buildTypeButton('يومي', ScheduleType.daily),
        const SizedBox(width: 8),
        _buildTypeButton('أسبوعي', ScheduleType.weekly),
        const SizedBox(width: 8),
        _buildTypeButton('شهري', ScheduleType.monthly),
      ],
    );
  }

  Widget _buildTypeButton(String label, ScheduleType type) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedType = type;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? AppTheme.primaryColor
              : Colors.grey.shade200,
          foregroundColor: isSelected ? Colors.white : Colors.black,
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildDaysSelector() {
    final days = ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
        7,
        (index) {
          final isSelected = _selectedDays.contains(index);
          return FilterChip(
            label: Text(days[index]),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  _selectedDays.add(index);
                } else {
                  _selectedDays.remove(index);
                }
              });
            },
          );
        },
      ),
    );
  }
}