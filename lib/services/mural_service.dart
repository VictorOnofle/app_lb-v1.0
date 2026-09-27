import '../models/mural_post_model.dart';

class MuralService {
  Future<List<MuralPost>> buscarPosts() async {
    // Simula o tempo de rede
    await Future.delayed(const Duration(seconds: 1));

    // No futuro, isso será algo como: FirebaseFirestore.instance.collection('mural').get();
    return [
      MuralPost(
        id: '1',
        title: 'Acidente na Rodovia: Mudança de Rota!',
        description: 'Atenção todos no comboio, desvio imediato pela saída 42. Informem os garupas.',
        importance: 5,
        source: PostSource.rota,
        date: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      MuralPost(
        id: '2',
        title: 'Taxa da Festa de Aniversário Liberada',
        description: 'O valor da contribuição (R\$ 150) já está disponível na aba Tesouraria. Prazo até sexta!',
        importance: 4,
        source: PostSource.tesouraria,
        date: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      MuralPost(
        id: '3',
        title: 'Reunião Obrigatória de Escudados',
        description: 'Sexta-feira às 20h na Sede. Presença obrigatória para todos os membros Full Patch.',
        importance: 3,
        source: PostSource.agenda,
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      MuralPost(
        id: '4',
        title: 'Novo Próspero Aprovado',
        description: 'Dêem as boas-vindas ao nosso novo integrante, João "Cachorrão".',
        importance: 2,
        source: PostSource.perfil,
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }
}