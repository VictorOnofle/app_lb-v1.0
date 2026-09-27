// Define de onde veio o aviso
enum PostSource { mural, rota, tesouraria, agenda, perfil }

class MuralPost {
  final String id;
  final String title;
  final String description;
  final int importance;
  final PostSource source;
  final DateTime date;

  MuralPost({
    required this.id,
    required this.title,
    required this.description,
    required this.importance,
    required this.source,
    required this.date,
  });

  // Prepara o post para ser salvo na Nuvem (Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'importance': importance,
      'source': source.toString(), // Salva o enum como texto
      'date': date.toIso8601String(), // Salva a data no formato padrão de banco
    };
  }

  // Converte os dados da Nuvem de volta para o App
  factory MuralPost.fromMap(Map<String, dynamic> map) {
    return MuralPost(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      importance: map['importance'] ?? 1,
      source: PostSource.values.firstWhere(
            (e) => e.toString() == map['source'],
        orElse: () => PostSource.mural, // Padrão caso não encontre
      ),
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
    );
  }
}