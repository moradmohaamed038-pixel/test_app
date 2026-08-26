class EspDevice {
  final String id;
  final String name;
  final String ipAddress;
  final String macAddress;
  final String firmwareVersion;
  final bool isOnline;
  final DateTime lastSeen;
  final List<Relay> relays;
  final Sensor tankSensor;
  final Sensor voltageSensor;
  final String location;
  final String ownerId;

  EspDevice({
    this.id = '',
    this.name = 'ESP32',
    this.ipAddress = '',
    this.macAddress = '',
    this.firmwareVersion = '1.0.0',
    this.isOnline = false,
    DateTime? lastSeen,
    List<Relay>? relays,
    Sensor? tankSensor,
    Sensor? voltageSensor,
    this.location = '',
    this.ownerId = '',
  })  : lastSeen = lastSeen ?? DateTime.now(),
        relays = relays ?? List.generate(12, (i) => Relay(id: 'R${i + 1}')),
        tankSensor = tankSensor ?? Sensor(id: 'tank', name: 'Tank Level'),
        voltageSensor = voltageSensor ?? Sensor(id: 'voltage', name: 'Voltage');

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ipAddress': ipAddress,
      'macAddress': macAddress,
      'firmwareVersion': firmwareVersion,
      'isOnline': isOnline,
      'lastSeen': lastSeen.toIso8601String(),
      'location': location,
      'ownerId': ownerId,
    };
  }

  factory EspDevice.fromMap(Map<String, dynamic> map) {
    return EspDevice(
      id: map['id'] ?? '',
      name: map['name'] ?? 'ESP32',
      ipAddress: map['ipAddress'] ?? '',
      macAddress: map['macAddress'] ?? '',
      firmwareVersion: map['firmwareVersion'] ?? '1.0.0',
      isOnline: map['isOnline'] ?? false,
      lastSeen: map['lastSeen'] != null 
          ? DateTime.parse(map['lastSeen']) 
          : DateTime.now(),
      location: map['location'] ?? '',
      ownerId: map['ownerId'] ?? '',
    );
  }

  EspDevice copyWith({
    String? id,
    String? name,
    String? ipAddress,
    String? macAddress,
    String? firmwareVersion,
    bool? isOnline,
    DateTime? lastSeen,
    List<Relay>? relays,
    Sensor? tankSensor,
    Sensor? voltageSensor,
    String? location,
    String? ownerId,
  }) {
    return EspDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      ipAddress: ipAddress ?? this.ipAddress,
      macAddress: macAddress ?? this.macAddress,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      relays: relays ?? this.relays,
      tankSensor: tankSensor ?? this.tankSensor,
      voltageSensor: voltageSensor ?? this.voltageSensor,
      location: location ?? this.location,
      ownerId: ownerId ?? this.ownerId,
    );
  }
}