class LocationService {
  // Simula o registro do local seguro no banco de dados
  Future<bool> registrarCheckIn(String local) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula conexão
    return true;
  }

  // Simula o envio do alerta vermelho para os celulares da Diretoria
  Future<bool> dispararSOS(String localAtual) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula conexão
    return true;
  }
}