import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../services/auth_service.dart';

class RegistroViewModel extends ChangeNotifier {
  final AuthService _service = AuthService();
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;
  bool _isCodeValid = false;
  String? _errorMessage;

  // Arquivos em anexo
  PlatformFile? cnhFile;
  List<PlatformFile?> vehicleDocs = [];
  List<PlatformFile?> insuranceDocs = [];
  List<XFile> vehiclePhotos = [];

  bool get isLoading => _isLoading;
  bool get isCodeValid => _isCodeValid;
  String? get errorMessage => _errorMessage;

  // --- ACESSO RESTRITO ---
  Future<void> validarCodigoAcesso(String codigo) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _isCodeValid = await _service.validarCodigoDiretoria(codigo);
    if (!_isCodeValid) {
      _errorMessage = 'Código de acesso inválido ou expirado.';
    }

    _isLoading = false;
    notifyListeners();
  }

  // --- MANIPULAÇÃO DE ARQUIVOS ---
  Future<void> pickCnh() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) cnhFile = result.files.first;
    notifyListeners();
  }

  Future<void> pickVehicleDoc(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) vehicleDocs[index] = result.files.first;
    notifyListeners();
  }

  Future<void> pickInsuranceDoc(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) insuranceDocs[index] = result.files.first;
    notifyListeners();
  }

  Future<String?> pickVehiclePhoto() async {
    if (vehiclePhotos.length >= 5) return 'Limite máximo de 5 fotos atingido.';

    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      vehiclePhotos.add(image);
      notifyListeners();
    }
    return null; // Sem erros
  }

  void atualizarListas(int vCount, int iCount) {
    if (vehicleDocs.length < vCount) vehicleDocs.addAll(List.filled(vCount - vehicleDocs.length, null));
    else if (vehicleDocs.length > vCount) vehicleDocs.removeRange(vCount, vehicleDocs.length);

    if (insuranceDocs.length < iCount) insuranceDocs.addAll(List.filled(iCount - insuranceDocs.length, null));
    else if (insuranceDocs.length > iCount) insuranceDocs.removeRange(iCount, insuranceDocs.length);
    notifyListeners();
  }

  // --- SUBMISSÃO ---
  Future<bool> solicitarCadastro(Map<String, dynamic> dadosCompletos) async {
    _isLoading = true;
    notifyListeners();

    // Aqui você juntaria as variáveis (arquivos) com o map (dados texto) para enviar
    bool sucesso = await _service.enviarCadastroCompleto(dadosCompletos);

    _isLoading = false;
    notifyListeners();
    return sucesso;
  }
}