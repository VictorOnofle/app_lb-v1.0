import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/perfil_viewmodel.dart';
import 'login_page.dart';

class PerfilTab extends StatelessWidget {
  const PerfilTab({super.key});

  Widget _buildPrefIcon(String pref) {
    bool isWpp = pref.toLowerCase() == 'whatsapp';
    return Icon(
      isWpp ? Icons.chat_bubble_outline : Icons.phone,
      size: 16,
      color: isWpp ? Colors.greenAccent : Colors.blueAccent,
    );
  }

  void _abrirEdicaoDados(BuildContext context, PerfilViewModel viewModel) {
    final perfil = viewModel.perfil;
    if (perfil == null) return;

    final apelidoCtrl = TextEditingController(text: perfil.apelido);
    final nomeCtrl = TextEditingController(text: perfil.nomeCompleto);
    final motoCtrl = TextEditingController(text: perfil.moto);
    final sangueCtrl = TextEditingController(text: perfil.tipoSanguineo);
    final emerg1Ctrl = TextEditingController(text: perfil.contatoEmergencia1);
    final emerg2Ctrl = TextEditingController(text: perfil.contatoEmergencia2);

    String modalPrefEmerg1 = perfil.prefEmergencia1;
    String modalPrefEmerg2 = perfil.prefEmergencia2;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF151515),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[700], borderRadius: BorderRadius.circular(10))),
                  const SizedBox(height: 24),
                  const Text('Editar Dados Pessoais', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 16),
                  TextField(controller: apelidoCtrl, decoration: const InputDecoration(labelText: 'Apelido (no MC)')),
                  const SizedBox(height: 12),
                  TextField(controller: nomeCtrl, decoration: const InputDecoration(labelText: 'Nome Completo')),
                  const SizedBox(height: 12),
                  TextField(controller: motoCtrl, decoration: const InputDecoration(labelText: 'Moto Principal')),
                  const SizedBox(height: 12),
                  TextField(controller: sangueCtrl, decoration: const InputDecoration(labelText: 'Tipo Sang.')),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(flex: 2, child: TextField(controller: emerg1Ctrl, decoration: const InputDecoration(labelText: 'Emergência 1'))),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField<String>(
                          value: modalPrefEmerg1,
                          decoration: const InputDecoration(labelText: 'Pref.'),
                          items: const [DropdownMenuItem(value: 'WhatsApp', child: Text('WhatsApp', style: TextStyle(fontSize: 12))), DropdownMenuItem(value: 'Ligação', child: Text('Ligação', style: TextStyle(fontSize: 12)))],
                          onChanged: (val) => setModalState(() => modalPrefEmerg1 = val!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(flex: 2, child: TextField(controller: emerg2Ctrl, decoration: const InputDecoration(labelText: 'Emergência 2'))),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField<String>(
                          value: modalPrefEmerg2,
                          decoration: const InputDecoration(labelText: 'Pref.'),
                          items: const [DropdownMenuItem(value: 'WhatsApp', child: Text('WhatsApp', style: TextStyle(fontSize: 12))), DropdownMenuItem(value: 'Ligação', child: Text('Ligação', style: TextStyle(fontSize: 12)))],
                          onChanged: (val) => setModalState(() => modalPrefEmerg2 = val!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      await viewModel.salvarEdicao(
                        apelido: apelidoCtrl.text,
                        nome: nomeCtrl.text,
                        moto: motoCtrl.text,
                        sangue: sangueCtrl.text,
                        emerg1: emerg1Ctrl.text,
                        emerg2: emerg2Ctrl.text,
                        pref1: modalPrefEmerg1,
                        pref2: modalPrefEmerg2,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dados atualizados com sucesso!'), backgroundColor: Color(0xFFFDD835)));
                    },
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                    child: const Text('SALVAR ALTERAÇÕES'),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _deletarMembroDiretoria(BuildContext context, PerfilViewModel viewModel) {
    final senhaDiretorCtrl = TextEditingController();
    final descricaoCtrl = TextEditingController();
    final ganchosCtrl = TextEditingController(text: '0');
    bool teveLuto = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E1E),
              title: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                  SizedBox(width: 8),
                  Text('Desligamento do Membro', style: TextStyle(color: Colors.redAccent)),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Esta ação encerrará o ciclo do membro no clube. Preencha o relatório de desligamento:', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Teve Luto?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      activeColor: Colors.redAccent,
                      value: teveLuto,
                      onChanged: (val) => setDialogState(() => teveLuto = val),
                    ),
                    const SizedBox(height: 12),
                    TextField(controller: ganchosCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Ganchos/Punições')),
                    const SizedBox(height: 12),
                    TextField(controller: descricaoCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Breve Descrição do Desligamento*')),
                    const SizedBox(height: 16),
                    TextField(controller: senhaDiretorCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Senha de Diretor*')),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR', style: TextStyle(color: Colors.white54))),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                  onPressed: () async {
                    if (descricaoCtrl.text.trim().isEmpty) return;

                    bool sucesso = await viewModel.confirmarDesligamento(
                      senhaDiretor: senhaDiretorCtrl.text,
                      descricao: descricaoCtrl.text,
                      ganchos: int.tryParse(ganchosCtrl.text) ?? 0,
                      teveLuto: teveLuto,
                    );

                    if (sucesso && context.mounted) {
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
                    } else if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Senha incorreta!'), backgroundColor: Colors.redAccent));
                    }
                  },
                  child: const Text('CONFIRMAR DESLIGAMENTO'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PerfilViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading || viewModel.perfil == null) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFFDD835)));
        }

        final p = viewModel.perfil!;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[900],
                    backgroundImage: viewModel.profileImage != null ? FileImage(File(viewModel.profileImage!.path)) : null,
                    child: viewModel.profileImage == null ? const Icon(Icons.person, size: 60, color: Colors.white54) : null,
                  ),
                  InkWell(
                    onTap: () => viewModel.alterarFotoGaleria(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 3)),
                      child: const Icon(Icons.camera_alt, color: Colors.black, size: 20),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(p.apelido, textAlign: TextAlign.center, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            Container(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: Colors.grey[850], borderRadius: BorderRadius.circular(12)),
                child: Text(p.cargo, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.redAccent.withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.redAccent.withOpacity(0.5))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [Icon(Icons.medical_information, color: Colors.redAccent), SizedBox(width: 8), Text('FICHA DE EMERGÊNCIA', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))]),
                    const Divider(color: Colors.white10, height: 24),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Tipo Sanguíneo:', style: TextStyle(color: Colors.white70)), Text(p.tipoSanguineo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))]),
                    const SizedBox(height: 16),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildPrefIcon(p.prefEmergencia1), const SizedBox(width: 8), Expanded(child: Text(p.contatoEmergencia1, style: const TextStyle(color: Colors.white)))]),
                    if (p.contatoEmergencia2.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildPrefIcon(p.prefEmergencia2), const SizedBox(width: 8), Expanded(child: Text(p.contatoEmergencia2, style: const TextStyle(color: Colors.white)))]),
                    ]
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.badge, color: Colors.white54), title: const Text('Nome Completo', style: TextStyle(color: Colors.white54, fontSize: 12)), subtitle: Text(p.nomeCompleto, style: const TextStyle(color: Colors.white, fontSize: 16))),
            ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.two_wheeler, color: Colors.white54), title: const Text('Motocicleta', style: TextStyle(color: Colors.white54, fontSize: 12)), subtitle: Text(p.moto, style: const TextStyle(color: Colors.white, fontSize: 16))),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => _abrirEdicaoDados(context, viewModel),
              icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
              label: Text('EDITAR MEUS DADOS', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 50), side: BorderSide(color: Theme.of(context).colorScheme.primary)),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _deletarMembroDiretoria(context, viewModel),
              icon: const Icon(Icons.person_off, color: Colors.redAccent),
              label: const Text('DESLIGAR MEMBRO', style: TextStyle(color: Colors.redAccent)),
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 50), side: const BorderSide(color: Colors.redAccent)),
            ),
            const SizedBox(height: 32),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: Colors.grey[900],
              leading: const Icon(Icons.logout, color: Colors.white54),
              title: const Text('Sair do App', style: TextStyle(color: Colors.white54)),
              onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage())),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}