import '../models/membro_irmandade_model.dart';

class MembrosService {
  Future<List<MembroIrmandade>> buscarMembros() async {
    // Simula o tempo de carregamento da internet (Firebase/API)
    await Future.delayed(const Duration(seconds: 1));

    // Aqui no futuro trocaremos por: FirebaseFirestore.instance.collection('membros').get()
    return [
      MembroIrmandade(apelido: 'Cachorrão', nome: 'João Silva', cargo: 'Diretor', telefone: '(11) 98888-8888', prefContato: 'WhatsApp', emergencia1: 'Maria (Esposa) - (11) 97777-7777', prefEmergencia1: 'Ligação', emergencia2: 'Pedro (Irmão) - (11) 96666-6666', prefEmergencia2: 'WhatsApp'),
      MembroIrmandade(apelido: 'Fumaça', nome: 'Carlos Souza', cargo: 'Próspero', telefone: '(11) 95555-5555', prefContato: 'Ligação', emergencia1: 'Ana (Mãe) - (11) 94444-4444', prefEmergencia1: 'WhatsApp'),
      MembroIrmandade(apelido: 'Trovão', nome: 'Roberto Alves', cargo: 'Diretor Fundador', telefone: '(11) 93333-3333', prefContato: 'WhatsApp', emergencia1: 'Juliana (Esposa) - (11) 92222-2222', prefEmergencia1: 'Ligação'),
      MembroIrmandade(apelido: 'Caveira', nome: 'Marcos Costa', cargo: 'Membro Escudado', telefone: '(11) 91111-1111', prefContato: 'Ligação', emergencia1: 'Luiza (Filha) - (11) 90000-0000', prefEmergencia1: 'WhatsApp', emergencia2: 'José (Pai) - (11) 98989-8989', prefEmergencia2: 'Ligação'),
      MembroIrmandade(apelido: 'Sombra', nome: 'Diego Lima', cargo: 'Nômade', telefone: '(11) 97878-7878', prefContato: 'WhatsApp', emergencia1: 'Cláudia (Irmã) - (11) 96767-6767', prefEmergencia1: 'WhatsApp'),
    ];
  }
}