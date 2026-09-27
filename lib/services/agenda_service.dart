import '../models/evento_model.dart';

class AgendaService {
  Future<List<EventoMC>> buscarEventos() async {
    await Future.delayed(const Duration(seconds: 1)); // Simula internet

    // Os seus dados base de teste originais:
    return [
      EventoMC(
        id: '1', titulo: 'Bate e Volta - Serra', data: DateTime.now().add(const Duration(days: 2)), horario: '07:00', descricao: 'Ponto de encontro na Sede. Todos com tanque cheio!', temBanner: true, status: 'Aprovado', tipo: 'role', linkLocalizacao: 'https://maps.google.com/?q=serra', sugeridoPor: 'Diretoria', totalJoia: 12, totalNaoJoia: 2, totalPensando: 4,
      ),
      EventoMC(
        id: '1_2', titulo: 'Reunião Sede', data: DateTime.now().add(const Duration(days: 2)), horario: '20:00', descricao: 'Encontro para debater as contas do mês.', temBanner: false, status: 'Aprovado', tipo: 'reuniao', sugeridoPor: 'Diretoria', totalJoia: 5, totalNaoJoia: 0, totalPensando: 1,
      ),
      EventoMC(
        id: '2', titulo: 'Aniversário 5 Anos do Clube', data: DateTime.now().add(const Duration(days: 15)), horario: '14:00', descricao: 'Festa aberta na sede. Muito churrasco e rock n roll!', temBanner: true, status: 'Aprovado', tipo: 'aniversario', totalJoia: 35, totalNaoJoia: 0, totalPensando: 8,
      ),
      EventoMC(
        id: '3', titulo: 'Festa Surpresa Cachorrão', data: DateTime.now().add(const Duration(days: 5)), horario: '19:30', descricao: 'Churrasco surpresa, cheguem cedo e não avisem ele!', temBanner: false, status: 'Aprovado', tipo: 'aniversario', isFestaSurpresa: true, aniversarianteNome: 'Cachorrão',
      ),
      EventoMC(
        id: '4', titulo: 'Lava Motos Solidário', data: DateTime.now().add(const Duration(days: 8)), horario: '09:00', descricao: 'Vamos arrecadar ração para os cachorros de rua.', temBanner: false, status: 'Pendente', tipo: 'role', sugeridoPor: 'Fumaça',
      ),
    ];
  }
}