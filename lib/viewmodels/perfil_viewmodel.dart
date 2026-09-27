import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/perfil_model.dart';
import '../services/perfil_service.dart';

class PerfilViewModel extends ChangeNotifier {
  final PerfilService _service = PerfilService();
  final ImagePicker _picker = ImagePicker();

  PerfilModel? _perfil;
  bool _isLoading = false;
  XFile? _profileImage;

  PerfilModel? get perfil => _perfil;
  bool get isLoading => _isLoading;
  XFile? get profileImage => _profileImage;

  Future<void> carregarDados() async {
    _isLoading = true;
    notifyListeners();

    _perfil = await _service.carregarPerfil();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> alterarFotoGaleria() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _profileImage = image;
      notifyListeners();
    }
  }

  Future<bool> salvarEdicao({
    required String apelido,
    required String nome,
    required String moto,
    required String sangue,
    required String emerg1,
    required String emerg2,
    required String pref1,
    required String pref2,
  }) async {
    if (_perfil == null) return false;

    _perfil!.apelido = apelido;
    _perfil!.nomeCompleto = nome;
    _perfil!.moto = moto;
    _perfil!.tipoSanguineo = sangue;
    _perfil!.contatoEmergencia1 = emerg1;
    _perfil!.contatoEmergencia2 = emerg2;
    _perfil!.prefEmergencia1 = pref1;
    _perfil!.prefEmergencia2 = pref2;

    notifyListeners();
    return await _service.atualizarPerfil(_perfil!);
  }

  Future<bool> confirmarDesligamento({
    required String senhaDiretor,
    required String descricao,
    required int ganchos,
    required bool teveLuto,
  }) async {
    if (senhaDiretor != '123456') return false; // Validação simulada de segurança
    return await _service.desligarMembro(descricao, ganchos, teveLuto);
  }
}