class DeviceCommand {
  final String id;
  final String deviceId;
  final String relayId;
  final CommandType type;
  final bool value; // true = ON, false = OFF
  final DateTime timestamp;
  final String userId;
  CommandStatus status;
  String? errorMessage;

  DeviceCommand({
    required this.id,
    required this.deviceId,
    required this.relayId,
    required this.type,
    required this.value,
    required this.userId,
    DateTime? timestamp,
    this.status = CommandStatus.pending,
    this.errorMessage,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deviceId': deviceId,
      'relayId': relayId,
      'type': type.toString(),
      'value': value,
      'timestamp': timestamp.toIso8601String(),
      'userId': userId,
      'status': status.toString(),
      'errorMessage': errorMessage,
    };
  }

  factory DeviceCommand.fromMap(Map<String, dynamic> map) {
    return DeviceCommand(
      id: map['id'] ?? '',
      deviceId: map['deviceId'] ?? '',
      relayId: map['relayId'] ?? '',
      type: _parseCommandType(map['type']),
      value: map['value'] ?? false,
      userId: map['userId'] ?? '',
      timestamp: map['timestamp'] != null 
          ? DateTime.parse(map['timestamp']) 
          : DateTime.now(),
      status: _parseCommandStatus(map['status']),
      errorMessage: map['errorMessage'],
    );
  }
}

enum CommandType { toggleRelay, setTimer, setSchedule, getStatus }
enum CommandStatus { pending, executing, success, failed }

CommandType _parseCommandType(String? type) {
  switch (type) {
    case 'CommandType.setTimer':
      return CommandType.setTimer;
    case 'CommandType.setSchedule':
      return CommandType.setSchedule;
    case 'CommandType.getStatus':
      return CommandType.getStatus;
    default:
      return CommandType.toggleRelay;
  }
}

CommandStatus _parseCommandStatus(String? status) {
  switch (status) {
    case 'CommandStatus.executing':
      return CommandStatus.executing;
    case 'CommandStatus.success':
      return CommandStatus.success;
    case 'CommandStatus.failed':
      return CommandStatus.failed;
    default:
      return CommandStatus.pending;
  }
}