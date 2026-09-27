import '../models/perfil_model.dart';

class PerfilService {
  Future<PerfilModel> carregarPerfil() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simula rede/banco

    // Dados mockados iniciais do usuário logado
    return PerfilModel(
      apelido: 'Cachorrão',
      nomeCompleto: 'João Silva',
      cargo: 'Membro Escudado',
      moto: 'Harley-Davidson Fat Boy',
      tipoSanguineo: 'O+',
      contatoEmergencia1: 'Maria (Esposa) - (11) 97777-7777',
      contatoEmergencia2: 'Pedro (Irmão) - (11) 96666-6666',
      prefEmergencia1: 'Ligação',
      prefEmergencia2: 'WhatsApp',
    );
  }

  Future<bool> atualizarPerfil(PerfilModel perfil) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula salvamento na nuvem
    return true;
  }

  Future<bool> desligarMembro(String motivo, int ganchos, bool teveLuto) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula envio de relatório à diretoria
    return true;
  }
}