import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/irmandade_viewmodel.dart';

class IrmandadeTab extends StatelessWidget {
  const IrmandadeTab({super.key});

  // Função auxiliar para exibir o ícone correto baseado na preferência
  Widget _buildPrefIcon(String pref) {
    bool isWpp = pref.toLowerCase() == 'whatsapp';
    return Icon(
      isWpp ? Icons.chat_bubble_outline : Icons.phone,
      size: 16,
      color: isWpp ? Colors.greenAccent : Colors.blueAccent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IrmandadeViewModel>(
      builder: (context, viewModel, child) {
        // Mostra loading enquanto busca do Firebase/API
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFFDD835)));
        }

        // Caso não tenha membros
        if (viewModel.membros.isEmpty) {
          return const Center(child: Text('Nenhum membro encontrado.', style: TextStyle(color: Colors.white54)));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: viewModel.membros.length,
          itemBuilder: (context, index) {
            final membro = viewModel.membros[index];
            bool isPrincipalWpp = membro.prefContato.toLowerCase() == 'whatsapp';

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[800],
                          child: const Icon(Icons.person, size: 35, color: Colors.white54),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(membro.apelido, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(color: Colors.grey[850], borderRadius: BorderRadius.circular(4)),
                                child: Text(membro.cargo, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(isPrincipalWpp ? Icons.chat : Icons.phone, color: isPrincipalWpp ? Colors.greenAccent : Colors.blueAccent),
                          style: IconButton.styleFrom(backgroundColor: (isPrincipalWpp ? Colors.greenAccent : Colors.blueAccent).withOpacity(0.1)),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: Colors.white10),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.emergency, color: Colors.redAccent, size: 18),
                              SizedBox(width: 8),
                              Text('CONTATOS DE EMERGÊNCIA', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPrefIcon(membro.prefEmergencia1),
                              const SizedBox(width: 8),
                              Expanded(child: Text(membro.emergencia1, style: const TextStyle(color: Colors.white, fontSize: 14))),
                            ],
                          ),
                          if (membro.emergencia2 != null && membro.emergencia2!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildPrefIcon(membro.prefEmergencia2!),
                                const SizedBox(width: 8),
                                Expanded(child: Text(membro.emergencia2!, style: const TextStyle(color: Colors.white, fontSize: 14))),
                              ],
                            ),
                          ]
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}