import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/recuperacao_viewmodel.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RECUPERAR SENHA')),
      body: Consumer<RecuperacaoViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFFDD835)));
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (viewModel.currentStep == 0) ...[
                  const Icon(Icons.lock_reset, size: 80, color: Color(0xFFFDD835)),
                  const SizedBox(height: 24),
                  const Text('Informe seu celular cadastrado.', textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  TextField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Telefone com DDD', prefixIcon: Icon(Icons.phone))),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: RadioListTile<String>(title: const Text('WhatsApp'), value: 'whatsapp', groupValue: viewModel.deliveryMethod, onChanged: (val) => viewModel.setDeliveryMethod(val!))),
                      Expanded(child: RadioListTile<String>(title: const Text('SMS'), value: 'sms', groupValue: viewModel.deliveryMethod, onChanged: (val) => viewModel.setDeliveryMethod(val!))),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(onPressed: () => viewModel.enviarCodigo(_phoneController.text), child: const Text('ENVIAR CÓDIGO')),
                ] else if (viewModel.currentStep == 1) ...[
                  const Icon(Icons.message, size: 80, color: Color(0xFFFDD835)),
                  const SizedBox(height: 24),
                  Text('Digite o código enviado para ${_phoneController.text}', textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  TextField(controller: _otpController, keyboardType: TextInputType.number, maxLength: 6, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, letterSpacing: 8)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                      onPressed: () async {
                        bool sucesso = await viewModel.verificarCodigo(_otpController.text);
                        if (!sucesso && context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Código inválido.'), backgroundColor: Colors.red));
                      },
                      child: const Text('VALIDAR CÓDIGO')
                  ),
                  TextButton(onPressed: viewModel.voltarEtapaZero, child: const Text('Voltar')),
                ] else if (viewModel.currentStep == 2) ...[
                  const Icon(Icons.check_circle, size: 80, color: Colors.green),
                  const SizedBox(height: 24),
                  TextField(controller: _newPasswordController, obscureText: true, decoration: const InputDecoration(labelText: 'Nova Senha', prefixIcon: Icon(Icons.lock))),
                  const SizedBox(height: 16),
                  TextField(controller: _confirmPasswordController, obscureText: true, decoration: const InputDecoration(labelText: 'Confirme', prefixIcon: Icon(Icons.lock))),
                  const SizedBox(height: 24),
                  ElevatedButton(
                      onPressed: () async {
                        bool sucesso = await viewModel.redefinirSenha(_newPasswordController.text, _confirmPasswordController.text);
                        if (sucesso && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Senha alterada!'), backgroundColor: Colors.green));
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('REDEFINIR SENHA')
                  ),
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}