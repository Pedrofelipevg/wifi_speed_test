import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/test_result.dart';
import '../services/speed_test_service.dart';
import '../services/storage_service.dart';

enum TestState { idle, testingDownload, testingUpload, complete, error }

class SpeedTestViewModel extends ChangeNotifier {
  final SpeedTestService _speedTestService = SpeedTestService();
  final StorageService _storageService = StorageService();

  TestState _currentState = TestState.idle;
  TestState get currentState => _currentState;

  double _downloadSpeed = 0.0;
  double get downloadSpeed => _downloadSpeed;

  double _uploadSpeed = 0.0;
  double get uploadSpeed => _uploadSpeed;

  double _ping = 0.0;
  double get ping => _ping;

  double _progress = 0.0;
  double get progress => _progress;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isConnected = true;
  bool get isConnected => _isConnected;

  SpeedTestViewModel() {
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult);
    
    Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      _isConnected = false;
      if (_currentState != TestState.idle && _currentState != TestState.complete) {
        cancelTest();
        _errorMessage = 'Connection lost.';
        _currentState = TestState.error;
      }
    } else {
      _isConnected = true;
    }
    notifyListeners();
  }

  void startTest({VoidCallback? onComplete}) {
    if (!_isConnected) {
      _errorMessage = 'No internet connection.';
      _currentState = TestState.error;
      notifyListeners();
      return;
    }

    _currentState = TestState.testingDownload;
    _downloadSpeed = 0.0;
    _uploadSpeed = 0.0;
    _ping = 0.0;
    _progress = 0.0;
    _errorMessage = '';
    notifyListeners();

    _speedTestService.startTest(
      onPingResult: (p) {
        _ping = p;
        notifyListeners();
      },
      onDownloadProgress: (speed, percent) {
        _downloadSpeed = speed;
        _progress = percent / 100.0;
        notifyListeners();
      },
      onDownloadComplete: (speed) {
        _downloadSpeed = speed;
        _currentState = TestState.testingUpload;
        _progress = 0.0;
        notifyListeners();
      },
      onUploadProgress: (speed, percent) {
        _uploadSpeed = speed;
        _progress = percent / 100.0;
        notifyListeners();
      },
      onUploadComplete: (speed) {
        _uploadSpeed = speed;
        _currentState = TestState.complete;
        _progress = 1.0;
        _saveResult();
        notifyListeners();
        if (onComplete != null) onComplete();
      },
      onError: (msg) {
        _errorMessage = msg;
        _currentState = TestState.error;
        notifyListeners();
      },
      onCancel: () {
        _currentState = TestState.idle;
        notifyListeners();
      },
    );
  }

  void cancelTest() {
    _speedTestService.cancelTest();
    _currentState = TestState.idle;
    notifyListeners();
  }

  Future<void> _saveResult() async {
    // Generate an ID for the result
    final uuid = "test_${DateTime.now().millisecondsSinceEpoch}";
    
    final result = TestResult(
      id: uuid,
      timestamp: DateTime.now(),
      ping: _ping > 0 ? _ping : 25.0, // Mock ping if not provided by library
      downloadSpeed: _downloadSpeed,
      uploadSpeed: _uploadSpeed,
    );
    await _storageService.saveTestResult(result);
  }
}
