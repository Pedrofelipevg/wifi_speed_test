import 'package:flutter/material.dart';
import '../models/test_result.dart';
import '../services/storage_service.dart';

class HistoryViewModel extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<TestResult> _history = [];
  List<TestResult> get history => _history;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();

    _history = await _storageService.getHistory();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> clearHistory() async {
    await _storageService.clearHistory();
    _history = [];
    notifyListeners();
  }
}
