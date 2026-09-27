import '../models/Cobranca.dart';

class ExcelService {
  Future<bool> gerarPlanilha(List<Cobranca> cobrancas, int mesFiltro) async {
    // Aqui no futuro usaremos os pacotes 'excel' e 'path_provider'
    // para gerar o .xlsx real e salvar no celular do Diretor.

    // Simula o tempo de geração do arquivo
    await Future.delayed(const Duration(seconds: 2));

    // Retorna true indicando que gerou com sucesso
    return true;
  }
}