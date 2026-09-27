import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RecuperacaoViewModel extends ChangeNotifier {
  final AuthService _service = AuthService();

  int _currentStep = 0;
  String _deliveryMethod = 'whatsapp';
  bool _isLoading = false;

  int get currentStep => _currentStep;
  String get deliveryMethod => _deliveryMethod;
  bool get isLoading => _isLoading;

  void setDeliveryMethod(String method) {
    _deliveryMethod = method;
    notifyListeners();
  }

  void voltarEtapaZero() {
    _currentStep = 0;
    notifyListeners();
  }

  Future<bool> enviarCodigo(String telefone) async {
    if (telefone.isEmpty) return false;
    _isLoading = true;
    notifyListeners();

    bool sucesso = await _service.solicitarCodigo(telefone, _deliveryMethod);
    if (sucesso) _currentStep = 1;

    _isLoading = false;
    notifyListeners();
    return sucesso;
  }

  Future<bool> verificarCodigo(String codigo) async {
    _isLoading = true;
    notifyListeners();

    bool sucesso = await _service.validarCodigoRecuperacao(codigo);
    if (sucesso) _currentStep = 2;

    _isLoading = false;
    notifyListeners();
    return sucesso;
  }

  Future<bool> redefinirSenha(String novaSenha, String confirmacao) async {
    if (novaSenha != confirmacao || novaSenha.isEmpty) return false;

    _isLoading = true;
    notifyListeners();

    bool sucesso = await _service.redefinirSenha(novaSenha);

    _isLoading = false;
    notifyListeners();
    return sucesso;
  }
}