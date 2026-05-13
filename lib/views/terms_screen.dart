import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'home_screen.dart';

class TermsScreen extends StatefulWidget {
  final bool isReadOnly;

  const TermsScreen({super.key, this.isReadOnly = false});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool _accepted = false;
  final StorageService _storageService = StorageService();

  void _onConfirm() async {
    if (_accepted) {
      await _storageService.setTermsAccepted(true);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }

  void _onClose() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text('Termo de Aceitação'),
        backgroundColor: const Color(0xFF2A2A40),
        elevation: 0,
        leading: widget.isReadOnly ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _onClose,
        ) : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Termo de Ciência e Aceitação',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A40),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Este aplicativo realiza testes de velocidade de internet, incluindo verificação de conexão, latência, download e upload. Para executar esses testes, o app poderá utilizar a conexão ativa do dispositivo e consumir dados da rede, especialmente durante os testes de download e upload.\n\n'
                      'Os resultados apresentados são estimativas baseadas nas condições da rede no momento do teste, podendo variar de acordo com sinal Wi-Fi, distância do roteador, uso da rede por outros dispositivos, desempenho do servidor de teste, configurações do aparelho e qualidade da conexão.\n\n'
                      'Ao continuar, você declara estar ciente de que o aplicativo poderá utilizar tráfego de internet para realizar as medições e concorda com o funcionamento descrito.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (!widget.isReadOnly) ...[
                Row(
                  children: [
                    Checkbox(
                      value: _accepted,
                      onChanged: (value) {
                        setState(() {
                          _accepted = value ?? false;
                        });
                      },
                      activeColor: Colors.blueAccent,
                    ),
                    const Expanded(
                      child: Text(
                        'Li, estou ciente e aceito os termos de uso.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    disabledBackgroundColor: Colors.grey[700],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _accepted ? _onConfirm : null,
                  child: const Text(
                    'Confirmar e continuar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ] else ...[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _onClose,
                  child: const Text(
                    'Fechar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
