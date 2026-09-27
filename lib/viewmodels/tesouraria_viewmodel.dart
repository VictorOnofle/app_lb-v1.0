import 'package:flutter/material.dart';
import '../models/Cobranca.dart';
import '../services/excel_service.dart';

class TesourariaViewModel extends ChangeNotifier {
  final ExcelService _excelService = ExcelService();

  // 1. A lista de membros para o modal de rateio ler
  final List<MembroClube> todosOsMembros = [
    MembroClube(nome: 'Meu Perfil', cargo: 'Membro'),
    MembroClube(nome: 'Cachorrão', cargo: 'Membro'),
    MembroClube(nome: 'Fumaça', cargo: 'Diretor'),
    MembroClube(nome: 'Caveira', cargo: 'Membro'),
    MembroClube(nome: 'Zé do Pneu', cargo: 'Nômade'),
    MembroClube(nome: 'Visitante 1', cargo: 'Convidado'),
  ];

  // 2. A lógica que gera as cobranças do rateio
  void gerarCobrancasRateio(String nome, double valorParcela, int qtdParcelas, List<MembroClube> membros) {
    int mesAtual = DateTime.now().month;
    int anoAtual = DateTime.now().year;

    for (var membro in membros) {
      for (int p = 1; p <= qtdParcelas; p++) {
        int mesCobranca = mesAtual + (p - 1);
        int anoCobranca = anoAtual;
        if (mesCobranca > 12) {
          mesCobranca -= 12;
          anoCobranca++;
        }

        cobrancasGerais.add(Cobranca(
          id: 'r_gen_${DateTime.now().millisecondsSinceEpoch}_${membro.nome}_$p',
          titulo: nome,
          subtitulo: 'Parcela $p/$qtdParcelas',
          valor: valorParcela,
          status: 'Não Pago',
          tipo: 'Rateio',
          membroAlvo: membro.nome,
          mes: mesCobranca,
          ano: anoCobranca,
        ));
      }
    }
    notifyListeners();
  }

  // --- ESTADOS DA TELA ---
  String perfilTeste = 'Membro'; // Controle temporário de teste
  bool diretorModoGestao = true;
  int mesFiltroGestao = 8;

  List<Cobranca> cobrancasGerais = [];
  final Set<String> carrinho = {};
  bool isLoadingExcel = false;

  TesourariaViewModel() {
    gerarCobrancasIniciais();
  }

  // --- GETTERS (Filtros Inteligentes) ---
  List<Cobranca> get minhasCobrancas =>
      cobrancasGerais.where((c) => c.membroAlvo == 'Meu Perfil').toList();

  double get totalCarrinho {
    double total = 0;
    for (var id in carrinho) {
      final item = cobrancasGerais.firstWhere((c) => c.id == id);
      total += item.valor;
    }
    return total;
  }

  // --- AÇÕES DO USUÁRIO ---
  void alterarPerfilTeste(String novoPerfil) {
    perfilTeste = novoPerfil;
    carrinho.clear(); // Limpa o carrinho ao mudar de perfil
    notifyListeners();
  }

  void alternarModoGestao(bool isGestao) {
    diretorModoGestao = isGestao;
    notifyListeners();
  }

  void alterarMesFiltro(int novoMes) {
    mesFiltroGestao = novoMes;
    notifyListeners();
  }

  void toggleNoCarrinho(String id) {
    if (carrinho.contains(id)) {
      carrinho.remove(id);
    } else {
      carrinho.add(id);
    }
    notifyListeners();
  }

  void limparCarrinho() {
    carrinho.clear();
    notifyListeners();
  }

  void processarPagamento(String formaPagamento) {
    for (var id in carrinho) {
      final item = cobrancasGerais.firstWhere((c) => c.id == id);
      if (formaPagamento == 'PIX') {
        item.status = 'Pago';
        item.metodoPendente = null;
      } else {
        item.status = 'Pendente';
        item.metodoPendente = formaPagamento;
      }
      item.justificativa = null;
    }
    carrinho.clear();
    notifyListeners();
  }

  Future<void> exportarParaExcel() async {
    isLoadingExcel = true;
    notifyListeners();

    // Filtra as cobranças do mês selecionado antes de enviar para o Excel
    final cobrancasDoMes = cobrancasGerais.where((c) => c.mes == mesFiltroGestao).toList();
    await _excelService.gerarPlanilha(cobrancasDoMes, mesFiltroGestao);

    isLoadingExcel = false;
    notifyListeners();
  }

  // Mock inicial (Igual ao seu código original)
  void gerarCobrancasIniciais() {
    cobrancasGerais = [
      Cobranca(id: 'm_8', titulo: 'Mês 8', subtitulo: '8/12', valor: 50.00, status: 'Pendente', tipo: 'Mensalidade', membroAlvo: 'Meu Perfil', mes: 8, ano: 2026),
      Cobranca(id: 'm_9', titulo: 'Mês 9', subtitulo: '9/12', valor: 50.00, status: 'Não Pago', tipo: 'Mensalidade', membroAlvo: 'Meu Perfil', mes: 9, ano: 2026),
      Cobranca(id: 'out_1', titulo: 'Mensalidade Agosto', subtitulo: 'Cachorrão', valor: 50.00, status: 'Pago', tipo: 'Mensalidade', membroAlvo: 'Cachorrão', mes: 8, ano: 2026),
      Cobranca(id: 'out_2', titulo: 'Mensalidade Agosto', subtitulo: 'Fumaça', valor: 50.00, status: 'Pendente', tipo: 'Mensalidade', membroAlvo: 'Fumaça', mes: 8, ano: 2026, metodoPendente: 'Dinheiro', justificativa: 'Entreguei o dinheiro pro presidente ontem.'),
    ];
    notifyListeners();
  }
}
