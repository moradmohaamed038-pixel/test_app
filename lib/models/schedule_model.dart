class Schedule {
  final String id;
  final String relayId;
  final String name;
  final ScheduleType type; // daily, weekly, monthly
  final TimeOfDay time;
  final Duration duration;
  bool isEnabled;
  final List<int> daysOfWeek; // for weekly (0=Sunday, 6=Saturday)
  final int dayOfMonth; // for monthly

  Schedule({
    required this.id,
    required this.relayId,
    required this.name,
    required this.type,
    required this.time,
    required this.duration,
    this.isEnabled = true,
    List<int>? daysOfWeek,
    this.dayOfMonth = 1,
  }) : daysOfWeek = daysOfWeek ?? [1, 2, 3, 4, 5]; // Default: Weekdays

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'relayId': relayId,
      'name': name,
      'type': type.toString(),
      'time': '${time.hour}:${time.minute}',
      'duration': duration.inMinutes,
      'isEnabled': isEnabled,
      'daysOfWeek': daysOfWeek,
      'dayOfMonth': dayOfMonth,
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    final timeParts = (map['time'] as String).split(':');
    return Schedule(
      id: map['id'] ?? '',
      relayId: map['relayId'] ?? '',
      name: map['name'] ?? '',
      type: _parseScheduleType(map['type']),
      time: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      duration: Duration(minutes: map['duration'] ?? 60),
      isEnabled: map['isEnabled'] ?? true,
      daysOfWeek: List<int>.from(map['daysOfWeek'] ?? []),
      dayOfMonth: map['dayOfMonth'] ?? 1,
    );
  }

  bool shouldRunToday() {
    if (!isEnabled) return false;
    if (type == ScheduleType.daily) return true;
    if (type == ScheduleType.weekly) {
      return daysOfWeek.contains(DateTime.now().weekday % 7);
    }
    if (type == ScheduleType.monthly) {
      return DateTime.now().day == dayOfMonth;
    }
    return false;
  }
}

enum ScheduleType { daily, weekly, monthly }

ScheduleType _parseScheduleType(String? type) {
  switch (type) {
    case 'ScheduleType.weekly':
      return ScheduleType.weekly;
    case 'ScheduleType.monthly':
      return ScheduleType.monthly;
    default:
      return ScheduleType.daily;
  }
}

class TimeOfDay {
  final int hour;
  final int minute;

  TimeOfDay({required this.hour, required this.minute});

  @override
  String toString() => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}