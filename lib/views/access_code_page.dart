import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/registro_viewmodel.dart';
import 'register_page.dart'; // Onde ficará a RegisterPage

class AccessCodePage extends StatefulWidget {
  const AccessCodePage({super.key});

  @override
  State<AccessCodePage> createState() => _AccessCodePageState();
}

class _AccessCodePageState extends State<AccessCodePage> {
  final _codeController = TextEditingController();
  final List<String> _roles = ['Diretor Tesouraria', 'Diretor', 'Membro Escudado', 'Próspero', 'Nômade', 'Convidado'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ACESSO RESTRITO')),
      body: Consumer<RegistroViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) return const Center(child: CircularProgressIndicator(color: Color(0xFFFDD835)));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(viewModel.isCodeValid ? Icons.admin_panel_settings : Icons.security, size: 80, color: const Color(0xFFFDD835)),
                const SizedBox(height: 24),

                if (!viewModel.isCodeValid) ...[
                  const Text('Digite o código da diretoria:', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 32),
                  TextField(controller: _codeController, keyboardType: TextInputType.number, maxLength: 6, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, letterSpacing: 8), decoration: InputDecoration(hintText: '000000', errorText: viewModel.errorMessage, counterText: '')),
                  const SizedBox(height: 32),
                  ElevatedButton(onPressed: () => viewModel.validarCodigoAcesso(_codeController.text), child: const Text('VALIDAR CÓDIGO')),
                ] else ...[
                  const Text('Código aceito! Selecione o nível:', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  ..._roles.map((role) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 55), side: const BorderSide(color: Color(0xFFFDD835))),
                      onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => RegisterPage(userRole: role))),
                      child: Text(role, style: const TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}