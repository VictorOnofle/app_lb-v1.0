class EventoMC {
  final String id;
  final String titulo;
  final DateTime data;
  final String horario;
  final String descricao;
  final bool temBanner;
  String status;
  final bool isFestaSurpresa;
  final String? aniversarianteNome;
  final String sugeridoPor;
  final String tipo;
  final String? linkLocalizacao;

  String? reacaoUsuario;
  int totalJoia;
  int totalNaoJoia;
  int totalPensando;

  EventoMC({
    required this.id,
    required this.titulo,
    required this.data,
    required this.horario,
    required this.descricao,
    this.temBanner = false,
    this.status = 'Aprovado',
    this.isFestaSurpresa = false,
    this.aniversarianteNome,
    this.sugeridoPor = 'Diretoria',
    this.tipo = 'role',
    this.linkLocalizacao,
    this.reacaoUsuario,
    this.totalJoia = 0,
    this.totalNaoJoia = 0,
    this.totalPensando = 0,
  });

  // Prepara para o Banco de Dados (Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'data': data.toIso8601String(),
      'horario': horario,
      'descricao': descricao,
      'temBanner': temBanner,
      'status': status,
      'isFestaSurpresa': isFestaSurpresa,
      'aniversarianteNome': aniversarianteNome,
      'sugeridoPor': sugeridoPor,
      'tipo': tipo,
      'linkLocalizacao': linkLocalizacao,
      'reacaoUsuario': reacaoUsuario,
      'totalJoia': totalJoia,
      'totalNaoJoia': totalNaoJoia,
      'totalPensando': totalPensando,
    };
  }

  // Converte do Banco de Dados de volta para o App
  factory EventoMC.fromMap(Map<String, dynamic> map) {
    return EventoMC(
      id: map['id'] ?? '',
      titulo: map['titulo'] ?? '',
      data: map['data'] != null ? DateTime.parse(map['data']) : DateTime.now(),
      horario: map['horario'] ?? '',
      descricao: map['descricao'] ?? '',
      temBanner: map['temBanner'] ?? false,
      status: map['status'] ?? 'Aprovado',
      isFestaSurpresa: map['isFestaSurpresa'] ?? false,
      aniversarianteNome: map['aniversarianteNome'],
      sugeridoPor: map['sugeridoPor'] ?? 'Diretoria',
      tipo: map['tipo'] ?? 'role',
      linkLocalizacao: map['linkLocalizacao'],
      reacaoUsuario: map['reacaoUsuario'],
      totalJoia: map['totalJoia'] ?? 0,
      totalNaoJoia: map['totalNaoJoia'] ?? 0,
      totalPensando: map['totalPensando'] ?? 0,
    );
  }
}