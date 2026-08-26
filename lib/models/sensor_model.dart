class Sensor {
  final String id;
  final String name;
  double value;
  String unit;
  DateTime lastRead;
  double minValue;
  double maxValue;
  List<double> history;

  Sensor({
    required this.id,
    required this.name,
    this.value = 0.0,
    this.unit = '%',
    DateTime? lastRead,
    this.minValue = 0.0,
    this.maxValue = 100.0,
    List<double>? history,
  })  : lastRead = lastRead ?? DateTime.now(),
        history = history ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'unit': unit,
      'lastRead': lastRead.toIso8601String(),
      'minValue': minValue,
      'maxValue': maxValue,
      'history': history,
    };
  }

  factory Sensor.fromMap(Map<String, dynamic> map) {
    return Sensor(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      value: (map['value'] ?? 0.0).toDouble(),
      unit: map['unit'] ?? '%',
      lastRead: map['lastRead'] != null 
          ? DateTime.parse(map['lastRead']) 
          : DateTime.now(),
      minValue: (map['minValue'] ?? 0.0).toDouble(),
      maxValue: (map['maxValue'] ?? 100.0).toDouble(),
      history: List<double>.from(map['history'] ?? []),
    );
  }

  void updateValue(double newValue) {
    value = newValue;
    lastRead = DateTime.now();
    history.add(newValue);
    if (history.length > 100) {
      history.removeAt(0);
    }
  }

  double getAverage() {
    if (history.isEmpty) return 0.0;
    return history.reduce((a, b) => a + b) / history.length;
  }
}