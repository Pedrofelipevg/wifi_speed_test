import 'package:shared_preferences/shared_preferences.dart';
import '../models/test_result.dart';

class StorageService {
  static const String _keyHistory = 'speed_test_history';
  static const String _keyTerms = 'terms_accepted';

  Future<void> setTermsAccepted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyTerms, value);
  }

  Future<bool> getTermsAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyTerms) ?? false;
  }

  Future<void> saveTestResult(TestResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_keyHistory) ?? [];
    history.add(result.toJson());
    await prefs.setStringList(_keyHistory, history);
  }

  Future<List<TestResult>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_keyHistory) ?? [];
    return history.map((e) => TestResult.fromJson(e)).toList().reversed.toList();
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHistory);
  }
}
