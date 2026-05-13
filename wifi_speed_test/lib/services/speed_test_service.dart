import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;

class SpeedTestService {
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
      // We measure TCP connection latency to a reliable CDN (Cloudflare) 
      // instead of a full HTTP GET to avoid SSL/DNS/HTTP overhead.
      try {
        double bestPing = 999.0;
        // Perform 3 samples and take the minimum for better accuracy
        for (int i = 0; i < 3; i++) {
          if (_cancelled) break;
          final stopwatch = Stopwatch()..start();
          try {
            final socket = await Socket.connect('1.1.1.1', 80, timeout: const Duration(seconds: 2));
            stopwatch.stop();
            await socket.close();
            final currentPing = stopwatch.elapsedMilliseconds.toDouble();
            if (currentPing < bestPing) bestPing = currentPing;
          } catch (_) {}
          await Future.delayed(const Duration(milliseconds: 100));
        }

        if (_cancelled) { onCancel(); return; }
        onPingResult(bestPing == 999.0 ? 0.0 : bestPing);
      } catch (_) {
        onPingResult(0.0);
      }

      // --- Download ---
      // Use a 10MB file from speedtest.tele2.net
      final downloadUrl = 'https://link.testfile.org/15MB';
      final downloadStart = DateTime.now();
      double lastSpeed = 0;
      int bytesReceived = 0;
      const totalExpectedBytes = 15 * 1024 * 1024; // 15 MB

      final downloadRequest = http.Request('GET', Uri.parse(downloadUrl));
      final downloadResponse = await http.Client().send(downloadRequest);
      
      await for (final chunk in downloadResponse.stream) {
        if (_cancelled) { onCancel(); return; }
        bytesReceived += chunk.length;
        final elapsed = DateTime.now().difference(downloadStart).inMilliseconds / 1000.0;
        if (elapsed > 0) {
          lastSpeed = (bytesReceived * 8) / elapsed / 1000000; // Mbps
        }
        final progress = (bytesReceived / totalExpectedBytes * 100).clamp(0, 100);
        onDownloadProgress(lastSpeed, progress.toDouble());
        if (bytesReceived >= totalExpectedBytes) break;
      }
      if (_cancelled) { onCancel(); return; }
      onDownloadComplete(lastSpeed);

      // --- Upload ---
      final uploadDataSize = 5 * 1024 * 1024; // 5MB
      final uploadData = List.generate(uploadDataSize, (i) => i % 256);
      final uploadStart = DateTime.now();

      // Simulate upload progress (HTTP doesn't give byte-by-byte callbacks easily)
      int totalSent = 0;
      const chunkSize = 256 * 1024; // 256KB chunks
      while (totalSent < uploadDataSize && !_cancelled) {
        final end = (totalSent + chunkSize).clamp(0, uploadDataSize);
        final chunk = uploadData.sublist(totalSent, end);
        try {
          await http.post(
            Uri.parse('https://httpbin.org/post'),
            body: chunk,
          );
        } catch (_) {
          // Ignore individual chunk errors, keep timing
        }
        totalSent = end;
        final elapsed = DateTime.now().difference(uploadStart).inMilliseconds / 1000.0;
        final uploadSpeed = elapsed > 0 ? (totalSent * 8) / elapsed / 1000000 : 0.0;
        final progress = (totalSent / uploadDataSize * 100).clamp(0, 100);
        onUploadProgress(uploadSpeed.toDouble(), progress.toDouble());
      }
      if (_cancelled) { onCancel(); return; }
      final finalElapsed = DateTime.now().difference(uploadStart).inMilliseconds / 1000.0;
      final finalUploadSpeed = finalElapsed > 0 ? (uploadDataSize * 8) / finalElapsed / 1000000 : 0.0;
      onUploadComplete(finalUploadSpeed);
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
