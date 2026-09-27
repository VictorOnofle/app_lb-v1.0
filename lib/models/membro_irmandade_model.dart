class MembroIrmandade {
  final String apelido;
  final String nome;
  final String cargo;
  final String telefone;
  final String prefContato;
  final String emergencia1;
  final String prefEmergencia1;
  final String? emergencia2;
  final String? prefEmergencia2;

  MembroIrmandade({
    required this.apelido,
    required this.nome,
    required this.cargo,
    required this.telefone,
    required this.prefContato,
    required this.emergencia1,
    required this.prefEmergencia1,
    this.emergencia2,
    this.prefEmergencia2,
  });

  // Prepara o objeto para ser salvo na Nuvem (Firebase)
  Map<String, dynamic> toMap() {
    return {
      'apelido': apelido,
      'nome': nome,
      'cargo': cargo,
      'telefone': telefone,
      'prefContato': prefContato,
      'emergencia1': emergencia1,
      'prefEmergencia1': prefEmergencia1,
      'emergencia2': emergencia2,
      'prefEmergencia2': prefEmergencia2,
    };
  }

  // Converte os dados que vem da Nuvem de volta para o App
  factory MembroIrmandade.fromMap(Map<String, dynamic> map) {
    return MembroIrmandade(
      apelido: map['apelido'] ?? '',
      nome: map['nome'] ?? '',
      cargo: map['cargo'] ?? 'Convidado',
      telefone: map['telefone'] ?? '',
      prefContato: map['prefContato'] ?? 'WhatsApp',
      emergencia1: map['emergencia1'] ?? '',
      prefEmergencia1: map['prefEmergencia1'] ?? 'Ligação',
      emergencia2: map['emergencia2'],
      prefEmergencia2: map['prefEmergencia2'],
    );
  }
}