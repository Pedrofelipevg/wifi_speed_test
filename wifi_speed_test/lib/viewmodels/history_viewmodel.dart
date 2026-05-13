import 'package:flutter/material.dart';
import '../models/test_result.dart';
import '../repositories/speed_test_repository.dart';

class HistoryViewModel extends ChangeNotifier {
  final SpeedTestRepository _repository = SpeedTestRepository();

  List<TestResult> _history = [];
  List<TestResult> get history => _history;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      _history = await _repository.getHistory();
    } catch (e) {
      debugPrint('Error loading history: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }
}
