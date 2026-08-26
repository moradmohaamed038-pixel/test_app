class TimerConfig {
  final String id;
  final String relayId;
  int durationMinutes; // 1-120
  bool isActive;
  DateTime? startTime;
  TimerState state;

  TimerConfig({
    required this.id,
    required this.relayId,
    this.durationMinutes = 10,
    this.isActive = false,
    this.startTime,
    this.state = TimerState.stopped,
  });

  bool get isRunning => state == TimerState.running;
  
  int get remainingSeconds {
    if (startTime == null) return durationMinutes * 60;
    final elapsed = DateTime.now().difference(startTime!).inSeconds;
    final remaining = (durationMinutes * 60) - elapsed;
    return remaining > 0 ? remaining : 0;
  }

  bool get isExpired => remainingSeconds == 0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'relayId': relayId,
      'durationMinutes': durationMinutes,
      'isActive': isActive,
      'startTime': startTime?.toIso8601String(),
      'state': state.toString(),
    };
  }

  factory TimerConfig.fromMap(Map<String, dynamic> map) {
    return TimerConfig(
      id: map['id'] ?? '',
      relayId: map['relayId'] ?? '',
      durationMinutes: map['durationMinutes'] ?? 10,
      isActive: map['isActive'] ?? false,
      startTime: map['startTime'] != null 
          ? DateTime.parse(map['startTime']) 
          : null,
      state: _parseTimerState(map['state']),
    );
  }
}

enum TimerState { stopped, running, paused, expired }

TimerState _parseTimerState(String? state) {
  switch (state) {
    case 'TimerState.running':
      return TimerState.running;
    case 'TimerState.paused':
      return TimerState.paused;
    case 'TimerState.expired':
      return TimerState.expired;
    default:
      return TimerState.stopped;
  }
}