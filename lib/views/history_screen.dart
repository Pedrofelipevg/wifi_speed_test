import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/history_viewmodel.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HistoryViewModel>().loadHistory();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text('Test History'),
        backgroundColor: const Color(0xFF2A2A40),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              context.read<HistoryViewModel>().clearHistory();
            },
          )
        ],
      ),
      body: Consumer<HistoryViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
          }

          if (viewModel.history.isEmpty) {
            return const Center(
              child: Text("No test history available.", style: TextStyle(color: Colors.white70, fontSize: 16)),
            );
          }

          return ListView.builder(
            itemCount: viewModel.history.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final result = viewModel.history[index];
              final dateStr = DateFormat('MMM dd, yyyy - hh:mm a').format(result.timestamp);

              return Card(
                color: const Color(0xFF2A2A40),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dateStr, style: const TextStyle(color: Colors.white54, fontSize: 14)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildHistoryItem("Ping", "${result.ping.toStringAsFixed(1)} ms", Colors.blueAccent),
                          _buildHistoryItem("Down", "${result.downloadSpeed.toStringAsFixed(1)} Mbps", Colors.green),
                          _buildHistoryItem("Up", "${result.uploadSpeed.toStringAsFixed(1)} Mbps", Colors.amber),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHistoryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
