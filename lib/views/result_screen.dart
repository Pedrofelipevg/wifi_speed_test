import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final double downloadSpeed;
  final double uploadSpeed;
  final double ping;

  const ResultScreen({
    super.key,
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.ping,
  });

  @override
  Widget build(BuildContext context) {
    // Screen dimensions to make it responsive
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFF141526), // Dark specific to the image
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to Home
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // Top Metrics: Download & Upload
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBigMetric(
                  icon: Icons.arrow_circle_down_outlined,
                  iconColor: Colors.cyanAccent,
                  label: "DOWNLOAD Mbps",
                  value: downloadSpeed.toStringAsFixed(2),
                ),
                _buildBigMetric(
                  icon: Icons.arrow_circle_up_outlined,
                  iconColor: Colors.purpleAccent,
                  label: "UPLOAD Mbps",
                  value: uploadSpeed.toStringAsFixed(2),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Ping Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Ping ms", style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(width: 10),
                const Icon(Icons.compare_arrows, color: Colors.yellow, size: 20),
                const SizedBox(width: 5),
                Text(ping.toStringAsFixed(0), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 50),
            
            // Bottom Area (Responsive for Phone/Desktop layout)
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildLeftInfo(context)),
                  Expanded(child: _buildRightInfo()),
                ],
              )
            else
              Column(
                children: [
                  _buildLeftInfo(context),
                  const SizedBox(height: 40),
                  _buildRightInfo(),
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget _buildBigMetric({required IconData icon, required Color iconColor, required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 10),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.w300)),
      ],
    );
  }

  Widget _buildLeftInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // "INICIAR" Button like in the screenshot
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.cyanAccent, width: 2),
              color: Colors.transparent,
            ),
            alignment: Alignment.center,
            child: const Text(
              "INICIAR",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 30),
        // Mock Server Info
        _buildInfoRow(Icons.directions_outlined, "Conexões", "Multi", Colors.white70),
        const SizedBox(height: 15),
        _buildInfoRow(Icons.public, "WORLDNET FIBRA", "Ariquemes\nMudar de Servidor", Colors.cyanAccent, isAction: true),
        const SizedBox(height: 15),
        _buildInfoRow(Icons.person_outline, "Google", "72.14.201.203", Colors.white70),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle, Color subColor, {bool isAction = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white54, size: 28),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: subColor, fontSize: 14)),
          ],
        )
      ],
    );
  }

  Widget _buildRightInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "QUAL A PROBABILIDADE DE VOCÊ RECOMENDAR\nO APP PARA UM AMIGO OU COLEGA?",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          // NPS Buttons mock
          Wrap(
            spacing: 2,
            runSpacing: 5,
            alignment: WrapAlignment.center,
            children: List.generate(11, (index) {
              return Container(
                width: 35,
                height: 35,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2B3D),
                  border: Border.all(color: Colors.white12),
                ),
                child: Text("$index", style: const TextStyle(color: Colors.white70)),
              );
            }),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Nem um pouco provável", style: TextStyle(color: Colors.white54, fontSize: 12)),
              SizedBox(width: 30),
              Text("Extremamente provável", style: TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }
}
