import 'package:flutter/material.dart';
import '../models/mural_post_model.dart';
import '../services/mural_service.dart';

class MuralViewModel extends ChangeNotifier {
  final MuralService _service = MuralService();

  List<MuralPost> _posts = [];
  bool _isLoading = false;

  List<MuralPost> get posts => _posts;
  bool get isLoading => _isLoading;

  Future<void> carregarPosts() async {
    _isLoading = true;
    notifyListeners();

    List<MuralPost> listaCrua = await _service.buscarPosts();

    // Organiza para que o post mais recente fique no topo
    listaCrua.sort((a, b) => b.date.compareTo(a.date));

    _posts = listaCrua;
    _isLoading = false;
    notifyListeners();
  }

  // Lógica inteligente calculada no ViewModel
  String calcularTempoAtras(DateTime date) {
    Duration diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min atrás';
    if (diff.inHours < 24) return '${diff.inHours}h atrás';
    return '${diff.inDays} dias atrás';
  }
}