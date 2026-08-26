class Relay {
  final String id;
  final String name;
  bool isOn;
  final int gpio;
  int timerMinutes;
  bool hasSchedule;
  String scheduleType; // daily, weekly, monthly
  DateTime? scheduledTime;
  DateTime? lastToggled;

  Relay({
    required this.id,
    this.name = '',
    this.isOn = false,
    this.gpio = 0,
    this.timerMinutes = 0,
    this.hasSchedule = false,
    this.scheduleType = 'daily',
    this.scheduledTime,
    this.lastToggled,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isOn': isOn,
      'gpio': gpio,
      'timerMinutes': timerMinutes,
      'hasSchedule': hasSchedule,
      'scheduleType': scheduleType,
      'scheduledTime': scheduledTime?.toIso8601String(),
      'lastToggled': lastToggled?.toIso8601String(),
    };
  }

  factory Relay.fromMap(Map<String, dynamic> map) {
    return Relay(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      isOn: map['isOn'] ?? false,
      gpio: map['gpio'] ?? 0,
      timerMinutes: map['timerMinutes'] ?? 0,
      hasSchedule: map['hasSchedule'] ?? false,
      scheduleType: map['scheduleType'] ?? 'daily',
      scheduledTime: map['scheduledTime'] != null 
          ? DateTime.parse(map['scheduledTime']) 
          : null,
      lastToggled: map['lastToggled'] != null 
          ? DateTime.parse(map['lastToggled']) 
          : null,
    );
  }

  Relay copyWith({
    String? id,
    String? name,
    bool? isOn,
    int? gpio,
    int? timerMinutes,
    bool? hasSchedule,
    String? scheduleType,
    DateTime? scheduledTime,
    DateTime? lastToggled,
  }) {
    return Relay(
      id: id ?? this.id,
      name: name ?? this.name,
      isOn: isOn ?? this.isOn,
      gpio: gpio ?? this.gpio,
      timerMinutes: timerMinutes ?? this.timerMinutes,
      hasSchedule: hasSchedule ?? this.hasSchedule,
      scheduleType: scheduleType ?? this.scheduleType,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      lastToggled: lastToggled ?? this.lastToggled,
    );
  }
}