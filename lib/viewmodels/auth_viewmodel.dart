import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Função que será chamada quando o usuário apertar "ENTRAR"
  Future<bool> fazerLogin(String usuario, String senha) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // Avisa a tela para girar a bolinha de carregamento

    try {
      // Simula o tempo de resposta de uma API / Firebase
      await Future.delayed(const Duration(seconds: 2));

      // Regra de negócio simples para teste
      if (usuario.isNotEmpty && senha.isNotEmpty) {
        _isLoading = false;
        notifyListeners();
        return true; // Login Sucesso
      } else {
        _errorMessage = 'Preencha o usuário e a senha.';
        _isLoading = false;
        notifyListeners();
        return false; // Falhou
      }
    } catch (e) {
      _errorMessage = 'Erro ao conectar no servidor.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}