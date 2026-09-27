import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/mural_viewmodel.dart';
import '../models/mural_post_model.dart';

class MuralTab extends StatelessWidget {
  const MuralTab({super.key});

  // Estética visual (Cores)
  Color _getImportanceColor(int level) {
    switch (level) {
      case 5: return Colors.redAccent;
      case 4: return Colors.orange;
      case 3: return const Color(0xFFFDD835);
      case 2: return Colors.green;
      case 1: return Colors.grey;
      default: return Colors.grey;
    }
  }

  // Estética visual (Ícones)
  IconData _getSourceIcon(PostSource source) {
    switch (source) {
      case PostSource.tesouraria: return Icons.attach_money;
      case PostSource.rota: return Icons.map;
      case PostSource.agenda: return Icons.calendar_month;
      case PostSource.perfil: return Icons.person;
      case PostSource.mural: return Icons.campaign;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MuralViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFFDD835)));
        }

        if (viewModel.posts.isEmpty) {
          return const Center(child: Text('Nenhum aviso no mural no momento.', style: TextStyle(color: Colors.white54)));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: viewModel.posts.length,
          itemBuilder: (context, index) {
            final post = viewModel.posts[index];
            final postColor = _getImportanceColor(post.importance);

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                    color: post.importance >= 4 ? postColor : Colors.transparent,
                    width: 1.5
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: postColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: postColor),
                              ),
                              child: Text(
                                'Nível ${post.importance}',
                                style: TextStyle(color: postColor, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(_getSourceIcon(post.source), size: 20, color: Colors.grey[400]),
                          ],
                        ),
                        // Consumindo a lógica de tempo do ViewModel
                        Text(
                          viewModel.calcularTempoAtras(post.date),
                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      post.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      post.description,
                      style: const TextStyle(color: Colors.white70, height: 1.4),
                    ),
                    if (post.importance >= 4) ...[
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Futuro: Lógica de navegação baseada no post.source
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: postColor,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 45),
                        ),
                        child: Text(post.source == PostSource.tesouraria ? 'IR PARA TESOURARIA' : 'VER DETALHES'),
                      )
                    ]
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