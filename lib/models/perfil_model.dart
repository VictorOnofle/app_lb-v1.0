class PerfilModel {
  String apelido;
  String nomeCompleto;
  String cargo;
  String moto;
  String tipoSanguineo;
  String contatoEmergencia1;
  String contatoEmergencia2;
  String prefEmergencia1;
  String prefEmergencia2;
  String? fotoUrl;

  PerfilModel({
    required this.apelido,
    required this.nomeCompleto,
    required this.cargo,
    required this.moto,
    required this.tipoSanguineo,
    required this.contatoEmergencia1,
    required this.contatoEmergencia2,
    required this.prefEmergencia1,
    required this.prefEmergencia2,
    this.fotoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'apelido': apelido,
      'nomeCompleto': nomeCompleto,
      'cargo': cargo,
      'moto': moto,
      'tipoSanguineo': tipoSanguineo,
      'contatoEmergencia1': contatoEmergencia1,
      'contatoEmergencia2': contatoEmergencia2,
      'prefEmergencia1': prefEmergencia1,
      'prefEmergencia2': prefEmergencia2,
      'fotoUrl': fotoUrl,
    };
  }

  factory PerfilModel.fromMap(Map<String, dynamic> map) {
    return PerfilModel(
      apelido: map['apelido'] ?? '',
      nomeCompleto: map['nomeCompleto'] ?? '',      cargo: map['cargo'] ?? '',
      moto: map['moto'] ?? '',
      tipoSanguineo: map['tipoSanguineo'] ?? '',
      contatoEmergencia1: map['contatoEmergencia1'] ?? '',
      contatoEmergencia2: map['contatoEmergencia2'] ?? '',
      prefEmergencia1: map['prefEmergencia1'] ?? 'Ligação',
      prefEmergencia2: map['prefEmergencia2'] ?? 'WhatsApp',
      fotoUrl: map['fotoUrl'],
    );
  }
}