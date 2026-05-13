import 'dart:convert';

class TestResult {
  final String id;
  final DateTime timestamp;
  final double ping;
  final double downloadSpeed; // in Mbps
  final double uploadSpeed; // in Mbps

  TestResult({
    required this.id,
    required this.timestamp,
    required this.ping,
    required this.downloadSpeed,
    required this.uploadSpeed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'ping': ping,
      'downloadSpeed': downloadSpeed,
      'uploadSpeed': uploadSpeed,
    };
  }

  factory TestResult.fromMap(Map<String, dynamic> map) {
    return TestResult(
      id: map['id'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      ping: map['ping']?.toDouble() ?? 0.0,
      downloadSpeed: map['downloadSpeed']?.toDouble() ?? 0.0,
      uploadSpeed: map['uploadSpeed']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TestResult.fromJson(String source) => TestResult.fromMap(json.decode(source));
}
