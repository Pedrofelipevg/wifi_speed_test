import 'package:flutter_speed_test_plus/flutter_speed_test_plus.dart';

void main() {
  final test = FlutterInternetSpeedTest();
  test.startTesting(
    onStarted: () {},
    onCompleted: (TestResult a, TestResult b) {},
    onProgress: (double p, TestResult d) {},
    onError: (String a, String b) {},
    onDownloadComplete: (TestResult d) {},
    onUploadComplete: (TestResult u) {},
  );
}
