import 'package:flutter/material.dart';
import '../services/location_service.dart';

class RotaViewModel extends ChangeNotifier {
  final LocationService _service = LocationService();

  bool _isTraveling = false;
  bool _isLoading = false;

  String origemAtual = 'Sede';
  String destinoAtual = '';

  bool get isTraveling => _isTraveling;
  bool get isLoading => _isLoading;

  void iniciarViagem(String origem, String destino) {
    if (destino.isEmpty) return;

    origemAtual = origem;
    destinoAtual = destino;
    _isTraveling = true;
    notifyListeners();
  }

  void encerrarViagem() {
    _isTraveling = false;
    destinoAtual = '';
    notifyListeners();
  }

  Future<bool> fazerCheckInSeguranca() async {
    _isLoading = true;
    notifyListeners();

    // Aqui acionamos o Serviço que conectará com o Firebase
    bool sucesso = await _service.registrarCheckIn(destinoAtual);

    if (sucesso) {
      _isTraveling = false; // Finaliza a viagem visualmente
    }

    _isLoading = false;
    notifyListeners();
    return sucesso;
  }

  Future<bool> enviarAlertaSOS() async {
    _isLoading = true;
    notifyListeners();

    // Serviço que dispararia a notificação para a Diretoria
    bool sucesso = await _service.dispararSOS(origemAtual);

    _isLoading = false;
    notifyListeners();
    return sucesso;
  }
}