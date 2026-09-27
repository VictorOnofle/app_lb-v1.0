import 'package:flutter/material.dart';
import '../models/membro_irmandade_model.dart';
import '../services/membros_service.dart';

class IrmandadeViewModel extends ChangeNotifier {
  final MembrosService _service = MembrosService();

  List<MembroIrmandade> _membros = [];
  bool _isLoading = false;

  List<MembroIrmandade> get membros => _membros;
  bool get isLoading => _isLoading;

  // Lógica de hierarquia do Clube isolada da View
  int _getPesoCargo(String cargo) {
    switch (cargo) {
      case 'Diretor Fundador': return 1;
      case 'Diretor Tesouraria': return 2;
      case 'Diretor': return 3;
      case 'Membro Escudado': return 4;
      case 'Próspero': return 5;
      case 'Nômade': return 6;
      case 'Convidado': return 7;
      default: return 8;
    }
  }

  Future<void> carregarMembros() async {
    _isLoading = true;
    notifyListeners();

    // Busca os dados
    List<MembroIrmandade> listaCrua = await _service.buscarMembros();

    // Ordena os dados pela hierarquia
    listaCrua.sort((a, b) => _getPesoCargo(a.cargo).compareTo(_getPesoCargo(b.cargo)));

    _membros = listaCrua;
    _isLoading = false;
    notifyListeners();
  }
}