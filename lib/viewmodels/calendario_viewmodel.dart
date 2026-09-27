import 'package:flutter/material.dart';
import '../models/evento_model.dart';
import '../services/agenda_service.dart';

class CalendarioViewModel extends ChangeNotifier {
  final AgendaService _service = AgendaService();

  List<EventoMC> _eventos = [];
  bool _isLoading = false;

  // Controle de Estado da Tela
  DateTime _dataFocada = DateTime.now();
  bool _isDiretor = false;
  final String meuApelido = 'Cachorrão'; // Isso virá do AuthViewModel depois

  // Getters
  List<EventoMC> get eventos => _eventos;
  bool get isLoading => _isLoading;
  DateTime get dataFocada => _dataFocada;
  bool get isDiretor => _isDiretor;

  Future<void> carregarEventos() async {
    _isLoading = true;
    notifyListeners();

    _eventos = await _service.buscarEventos();

    _isLoading = false;
    notifyListeners();
  }

  // Ações de Estado
  void alterarModoDiretoria(bool valor) {
    _isDiretor = valor;
    notifyListeners();
  }

  void mudarMes(int incremento) {
    _dataFocada = DateTime(_dataFocada.year, _dataFocada.month + incremento, 1);
    notifyListeners();
  }

  // Regra de Negócio: Quem vê o quê?
  bool podeVerEvento(EventoMC e) {
    if (e.isFestaSurpresa && e.aniversarianteNome == meuApelido) return false;
    if (_isDiretor) return true;
    if (e.status == 'Aprovado' || e.sugeridoPor == meuApelido) return true;
    return false;
  }

  // Ações de Eventos
  void adicionarEvento(EventoMC novoEvento) {
    _eventos.add(novoEvento);
    notifyListeners();
  }

  void alterarStatusEvento(String id, String novoStatus) {
    final index = _eventos.indexWhere((e) => e.id == id);
    if (index != -1) {
      _eventos[index].status = novoStatus;
      notifyListeners();
    }
  }

  void reagirEvento(String id, String reacao) {
    final index = _eventos.indexWhere((e) => e.id == id);
    if (index != -1) {
      if (_eventos[index].reacaoUsuario == reacao) {
        _eventos[index].reacaoUsuario = null; // Tira a reação se clicar na mesma
      } else {
        _eventos[index].reacaoUsuario = reacao;
      }
      notifyListeners();
    }
  }
}