import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../viewmodels/speed_test_viewmodel.dart';
import 'history_screen.dart';
import 'result_screen.dart';
import 'terms_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Color _getSpeedColor(double speed) {
    if (speed < 10) return Colors.redAccent;
    if (speed < 50) return Colors.amber;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text('Wi-Fi Speed Test'),
        backgroundColor: const Color(0xFF2A2A40),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TermsScreen(isReadOnly: true)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            },
          )
        ],
      ),
      body: Consumer<SpeedTestViewModel>(
        builder: (context, viewModel, child) {
          final double currentDispSpeed = viewModel.currentState == TestState.testingUpload 
              ? viewModel.uploadSpeed 
              : viewModel.downloadSpeed;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!viewModel.isConnected)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.redAccent,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, color: Colors.white),
                      SizedBox(width: 8),
                      Text("No Internet Connection", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              if (viewModel.errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    viewModel.errorMessage,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),
              const SizedBox(height: 20),
              // Spedometer
              Expanded(
                child: Center(
                  child: SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        minimum: 0,
                        maximum: 100, // Or scale based on max speed
                        ranges: <GaugeRange>[
                          GaugeRange(startValue: 0, endValue: 10, color: Colors.redAccent),
                          GaugeRange(startValue: 10, endValue: 50, color: Colors.amber),
                          GaugeRange(startValue: 50, endValue: 100, color: Colors.green)
                        ],
                        pointers: <GaugePointer>[
                          NeedlePointer(
                            value: currentDispSpeed > 100 ? 100 : currentDispSpeed,
                            enableAnimation: true,
                            needleColor: Colors.white,
                            knobStyle: const KnobStyle(color: Colors.white),
                          )
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                            widget: Text(
                              '${currentDispSpeed.toStringAsFixed(1)}\nMbps',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            angle: 90,
                            positionFactor: 0.5,
                          )
                        ],
                        axisLabelStyle: const GaugeTextStyle(color: Colors.white),
                        majorTickStyle: const MajorTickStyle(color: Colors.white),
                        minorTickStyle: const MinorTickStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              // Results Details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildResultItem("Ping", "${viewModel.ping.toStringAsFixed(1)} ms", Colors.blueAccent),
                    _buildResultItem("Download", "${viewModel.downloadSpeed.toStringAsFixed(1)} Mbps", _getSpeedColor(viewModel.downloadSpeed)),
                    _buildResultItem("Upload", "${viewModel.uploadSpeed.toStringAsFixed(1)} Mbps", _getSpeedColor(viewModel.uploadSpeed)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Action Button
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: viewModel.currentState == TestState.idle || viewModel.currentState == TestState.complete || viewModel.currentState == TestState.error
                        ? Colors.blueAccent
                        : Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    if (viewModel.currentState == TestState.idle || viewModel.currentState == TestState.complete || viewModel.currentState == TestState.error) {
                      viewModel.startTest(
                        onComplete: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ResultScreen(
                                downloadSpeed: viewModel.downloadSpeed,
                                uploadSpeed: viewModel.uploadSpeed,
                                ping: viewModel.ping,
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      viewModel.cancelTest();
                    }
                  },
                  child: Text(
                    viewModel.currentState == TestState.idle || viewModel.currentState == TestState.complete || viewModel.currentState == TestState.error
                        ? 'START TEST'
                        : 'CANCEL',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              if (viewModel.currentState != TestState.idle && viewModel.currentState != TestState.complete && viewModel.currentState != TestState.error)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
                  child: LinearProgressIndicator(
                    value: viewModel.progress,
                    backgroundColor: Colors.grey[800],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      viewModel.currentState == TestState.testingDownload ? Colors.blueAccent : Colors.teal,
                    ),
                  ),
                ),
                if (viewModel.currentState != TestState.idle && viewModel.currentState != TestState.complete && viewModel.currentState != TestState.error)
                 Text(
                   viewModel.currentState == TestState.testingDownload ? "Testing Download..." : "Testing Upload...",
                   style: const TextStyle(color: Colors.white70),
                 )
            ],
          );
        },
      ),
    );
  }

  Widget _buildResultItem(String title, String value, Color valueColor) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(color: valueColor, fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
