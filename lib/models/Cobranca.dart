class MembroClube {
  final String nome;
  final String cargo;

  MembroClube({required this.nome, required this.cargo});
}

class Cobranca {
  String id;
  String titulo;
  String subtitulo;
  double valor;
  String status; // 'Pago', 'Não Pago', 'Pendente'
  String tipo; // 'Mensalidade', 'Rateio', 'Doacao'
  String membroAlvo;
  int mes;
  int ano;
  String? justificativa;
  String? metodoPendente;

  Cobranca({
    required this.id,
    required this.titulo,
    required this.subtitulo,
    required this.valor,
    required this.status,
    required this.tipo,
    required this.membroAlvo,
    required this.mes,
    required this.ano,
    this.justificativa,
    this.metodoPendente,
  });

  // Prepara o objeto para ser salvo no Firebase no futuro
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'subtitulo': subtitulo,
      'valor': valor,
      'status': status,
      'tipo': tipo,
      'membroAlvo': membroAlvo,
      'mes': mes,
      'ano': ano,
      'justificativa': justificativa,
      'metodoPendente': metodoPendente,
    };
  }

  // Converte os dados do Firebase de volta para o App
  factory Cobranca.fromMap(Map<String, dynamic> map) {
    return Cobranca(
      id: map['id'],
      titulo: map['titulo'],
      subtitulo: map['subtitulo'],
      valor: map['valor'],
      status: map['status'],
      tipo: map['tipo'],
      membroAlvo: map['membroAlvo'],
      mes: map['mes'],
      ano: map['ano'],
      justificativa: map['justificativa'],
      metodoPendente: map['metodoPendente'],
    );
  }
}