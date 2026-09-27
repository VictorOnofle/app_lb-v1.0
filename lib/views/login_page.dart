import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'home_screen.dart';
import 'forgot_password_page.dart';
import 'access_code_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'mc_logo',
                    child: Image.asset('assets/logo.png', height: 160),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'LOBOS CAFAJESTES MC',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  TextField(
                    controller: _loginController,
                    decoration: const InputDecoration(labelText: 'Usuário / Apelido', prefixIcon: Icon(Icons.person)),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Senha', prefixIcon: Icon(Icons.lock)),
                  ),
                  const SizedBox(height: 8),

                  // BOTÃO DE ESQUECEU A SENHA DE VOLTA!
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ForgotPasswordPage()));
                      },
                      style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.primary),
                      child: const Text('Esqueceu a senha?'),
                    ),
                  ),

                  if (authViewModel.errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(authViewModel.errorMessage, style: const TextStyle(color: Colors.red)),
                    ),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: authViewModel.isLoading
                        ? null
                        : () async {
                      bool sucesso = await authViewModel.fazerLogin(_loginController.text, _passwordController.text);
                      if (sucesso && context.mounted) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
                      }
                    },
                    child: authViewModel.isLoading ? const CircularProgressIndicator(color: Colors.black) : const Text('ENTRAR'),
                  ),

                  const SizedBox(height: 24),

                  // BOTÃO DE CADASTRO DE VOLTA!
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AccessCodePage()));
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.grey[400]),
                    child: const Text('Ainda não é membro? Cadastre-se'),
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