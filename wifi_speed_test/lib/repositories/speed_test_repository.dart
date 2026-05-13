import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/test_result.dart';

class SpeedTestRepository {
  final _supabase = Supabase.instance.client;

  Future<void> saveResult(TestResult result) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase.from('speed_tests').insert({
      'user_id': user.id,
      'ping': result.ping,
      'download_speed': result.downloadSpeed,
      'upload_speed': result.uploadSpeed,
      'timestamp': result.timestamp.toIso8601String(),
    });
  }

  Future<List<TestResult>> getHistory() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    final response = await _supabase
        .from('speed_tests')
        .select()
        .eq('user_id', user.id)
        .order('timestamp', ascending: false);

    return (response as List).map((data) {
      return TestResult(
        id: data['id'].toString(),
        timestamp: DateTime.parse(data['timestamp']),
        ping: (data['ping'] as num).toDouble(),
        downloadSpeed: (data['download_speed'] as num).toDouble(),
        uploadSpeed: (data['upload_speed'] as num).toDouble(),
      );
    }).toList();
  }
}
