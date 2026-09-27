import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../viewmodels/rota_viewmodel.dart';

class RotaTab extends StatefulWidget {
  const RotaTab({super.key});

  @override
  State<RotaTab> createState() => _RotaTabState();
}

class _RotaTabState extends State<RotaTab> {
  final _originController = TextEditingController(text: 'Sede');
  final _destinationController = TextEditingController();

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  void _showActionMenu(BuildContext context, RotaViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (bottomSheetContext) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4, margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(10)),
              ),
              ElevatedButton.icon(
                onPressed: viewModel.isLoading ? null : () async {
                  bool sucesso = await viewModel.fazerCheckInSeguranca();
                  if (sucesso && context.mounted) {
                    Navigator.pop(bottomSheetContext); // Fecha o menu
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Check-in confirmado! Viagem encerrada.', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), backgroundColor: Colors.greenAccent));
                  }
                },
                icon: const Icon(Icons.check_circle, size: 28),
                label: const Text('CHECK-IN DE SEGURANÇA', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 70), backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: viewModel.isLoading ? null : () async {
                  bool sucesso = await viewModel.enviarAlertaSOS();
                  if (sucesso && context.mounted) {
                    Navigator.pop(bottomSheetContext); // Fecha o menu
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('SOS ENVIADO! Diretoria notificada.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), backgroundColor: Colors.red, duration: Duration(seconds: 4)));
                  }
                },
                icon: const Icon(Icons.warning, size: 28, color: Colors.white),
                label: const Text('SOS EMERGÊNCIA', style: TextStyle(fontSize: 16, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 70), backgroundColor: Colors.red[800],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RotaViewModel>(
      builder: (context, viewModel, child) {

        // --- TELA 1: PREPARANDO A VIAGEM ---
        if (!viewModel.isTraveling) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.share_location, size: 80, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 24),
                TextField(controller: _originController, decoration: const InputDecoration(labelText: 'Origem', prefixIcon: Icon(Icons.my_location))),
                const SizedBox(height: 16),
                TextField(controller: _destinationController, decoration: const InputDecoration(labelText: 'Destino', prefixIcon: Icon(Icons.flag))),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (_destinationController.text.isNotEmpty) {
                      viewModel.iniciarViagem(_originController.text, _destinationController.text);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Digite o destino para iniciar a rota.')));
                    }
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 60), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  child: const Text('INICIAR VIAGEM'),
                )
              ],
            ),
          );
        }

        // --- TELA 2: EM VIAGEM (ANIMAÇÃO) ---
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: const Color(0xFF151515),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.grey[850]!, width: 1.5),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 15, offset: const Offset(0, 8))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        right: 0, top: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.cloudy_snowing, color: Colors.white70, size: 20),
                              const SizedBox(width: 8),
                              Transform.rotate(angle: 0.8, child: const Icon(Icons.navigation, color: Colors.lightBlueAccent, size: 18)),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 350, width: 350,
                            child: Lottie.asset('assets/animations/moto_rider.json', fit: BoxFit.contain, repeat: true),
                          ),
                          const SizedBox(height: 16),
                          const Text('01:29:45', style: TextStyle(fontSize: 42, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 2.0, fontFamily: 'monospace')),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _showActionMenu(context, viewModel),
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), shape: BoxShape.circle, border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3))),
                          child: Icon(Icons.keyboard_arrow_up, color: Theme.of(context).colorScheme.primary, size: 28),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Row(
                          children: [
                            Text(viewModel.origemAtual.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 13)),
                            const SizedBox(width: 12),
                            Container(width: 8, height: 8, decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle)),
                            Expanded(child: Container(height: 2, color: Theme.of(context).colorScheme.primary.withOpacity(0.5))),
                            Container(width: 8, height: 8, decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle)),
                            const SizedBox(width: 12),
                            Text(viewModel.destinoAtual.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}