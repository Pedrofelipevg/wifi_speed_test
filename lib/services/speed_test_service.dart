import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_speed_test_plus/flutter_speed_test_plus.dart';

class SpeedTestService {
  final FlutterInternetSpeedTest _speedTest = FlutterInternetSpeedTest();
  bool _cancelled = false;

  void startTest({
    required Function(double ping) onPingResult,
    required Function(double speed, double progress) onDownloadProgress,
    required Function(double speed) onDownloadComplete,
    required Function(double speed, double progress) onUploadProgress,
    required Function(double speed) onUploadComplete,
    required Function(String errorMessage) onError,
    required Function() onCancel,
  }) {
    _cancelled = false;
    _runTest(
      onPingResult: onPingResult,
      onDownloadProgress: onDownloadProgress,
      onDownloadComplete: onDownloadComplete,
      onUploadProgress: onUploadProgress,
      onUploadComplete: onUploadComplete,
      onError: onError,
      onCancel: onCancel,
    );
  }

  void cancelTest() {
    _cancelled = true;
    _speedTest.cancelTest();
  }

  Future<void> _runTest({
    required Function(double ping) onPingResult,
    required Function(double speed, double progress) onDownloadProgress,
    required Function(double speed) onDownloadComplete,
    required Function(double speed, double progress) onUploadProgress,
    required Function(double speed) onUploadComplete,
    required Function(String errorMessage) onError,
    required Function() onCancel,
  }) async {
    if (kIsWeb) {
      await _simulatedTest(
        onPingResult: onPingResult,
        onDownloadProgress: onDownloadProgress,
        onDownloadComplete: onDownloadComplete,
        onUploadProgress: onUploadProgress,
        onUploadComplete: onUploadComplete,
        onCancel: onCancel,
      );
      return;
    }

    try {
      // --- Ping ---
      // We manually fetch google.com to approximate latency, as flutter_speed_test_plus 
      // uses fast.com and may not expose a separate ping step before downloading.
      final pingStart = DateTime.now();
      try {
        await http.get(Uri.parse('https://www.google.com')).timeout(const Duration(seconds: 5));
        final pingMs = DateTime.now().difference(pingStart).inMilliseconds.toDouble();
        if (_cancelled) { onCancel(); return; }
        onPingResult(pingMs);
      } catch (_) {
        // If ping fails, don't break the whole test, let speed test library handle failure
        onPingResult(0.0);
      }

      _speedTest.startTesting(
        useFastApi: false,
        downloadTestServer: 'https://proof.ovh.net/files/1Mb.dat',
        uploadTestServer: 'https://httpbin.org/post',
        fileSizeInBytes: 1 * 1024 * 1024,
        onStarted: () {},
        onCompleted: (TestResult download, TestResult upload) {
          if (_cancelled) return;
        },
        onProgress: (double percent, TestResult data) {
          if (_cancelled) return;
          if (data.type == TestType.download) {
            onDownloadProgress(data.transferRate, percent);
          } else {
            onUploadProgress(data.transferRate, percent);
          }
        },
        onError: (String errorMessage, String speedTestError) {
          if (_cancelled) { onCancel(); return; }
          onError('Test failed: $errorMessage');
        },
        onDownloadComplete: (TestResult data) {
          if (_cancelled) return;
          onDownloadComplete(data.transferRate);
        },
        onUploadComplete: (TestResult data) {
          if (_cancelled) return;
          onUploadComplete(data.transferRate);
        },
        onCancel: () {
          onCancel();
        },
      );
    } catch (e) {
      if (_cancelled) {
        onCancel();
      } else {
        onError('Test failed: $e');
      }
    }
  }

  Future<void> _simulatedTest({
    required Function(double ping) onPingResult,
    required Function(double speed, double progress) onDownloadProgress,
    required Function(double speed) onDownloadComplete,
    required Function(double speed, double progress) onUploadProgress,
    required Function(double speed) onUploadComplete,
    required Function() onCancel,
  }) async {
    final rnd = Random();

    await Future.delayed(const Duration(milliseconds: 500));
    if (_cancelled) { onCancel(); return; }
    final ping = 15.0 + rnd.nextDouble() * 30.0;
    onPingResult(ping);

    double currentSpeed = 40.0 + rnd.nextDouble() * 20.0;
    for (int i = 1; i <= 20; i++) {
      await Future.delayed(const Duration(milliseconds: 250));
      if (_cancelled) { onCancel(); return; }
      currentSpeed = currentSpeed + (rnd.nextDouble() * 10.0 - 5.0);
      if (currentSpeed < 5.0) currentSpeed = 5.0;
      onDownloadProgress(currentSpeed, (i / 20.0) * 100);
    }
    onDownloadComplete(currentSpeed);

    currentSpeed = 10.0 + rnd.nextDouble() * 10.0;
    for (int i = 1; i <= 20; i++) {
      await Future.delayed(const Duration(milliseconds: 250));
      if (_cancelled) { onCancel(); return; }
      currentSpeed = currentSpeed + (rnd.nextDouble() * 4.0 - 2.0);
      if (currentSpeed < 2.0) currentSpeed = 2.0;
      onUploadProgress(currentSpeed, (i / 20.0) * 100);
    }
    onUploadComplete(currentSpeed);
  }
}
