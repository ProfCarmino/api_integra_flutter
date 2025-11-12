//
// =============================================================
//  CLASSE DE MODELO: Post
// =============================================================
//  Esta classe representa a estrutura de um objeto "Post"
//  (publicação, artigo ou registro) utilizado no aplicativo.
//
//   Responsabilidade única:
//     Definir o modelo de dados que descreve um post e
//     fornecer métodos utilitários para conversão entre
//     JSON (dados vindos da API) e objeto Dart.
//
//   Utilização típica:
//     - Receber dados de uma API (via método fromJson);
//     - Exibir informações do post na interface (PostList, PostForm);
//     - Enviar dados para criação ou atualização de posts.
//
//   Observação importante:
//     Essa classe **não possui interface visual** — é puramente lógica,
//     usada para transportar e estruturar informações.
//
class Post {
  // -------------------------------------------------------------
  // ATRIBUTOS
  // -------------------------------------------------------------
  // Cada campo representa uma propriedade do post.
  // Todos são imutáveis (final) após a criação do objeto.

  /// Identificador único do post
  final String id;

  /// Data de publicação ou referência textual (ex: "31 jul 2025").
  final String date;

  /// Título do post.
  final String title;

  /// Tempo estimado de leitura (ex: "3 minutos de leitura").
  final String readTime;

  /// Data e hora de criação no servidor (opcional).
  final String? createdAt;

  /// Data e hora da última atualização (opcional).
  final String? updatedAt;

  // -------------------------------------------------------------
  // CONSTRUTOR
  // -------------------------------------------------------------
  // Cria uma instância de Post com todos os campos necessários.
  // Os parâmetros marcados como "required" são obrigatórios,
  // enquanto os demais são opcionais (podem ser nulos).
  Post({
    required this.id,
    required this.date,
    required this.title,
    required this.readTime,
    this.createdAt,
    this.updatedAt,
  });

  // -------------------------------------------------------------
  // FÁBRICA fromJson()
  // -------------------------------------------------------------
  // Método de fábrica responsável por criar um objeto Post
  // a partir de um mapa JSON (como os retornados pela API REST).
  //
  // Exemplo de uso:
  //   final post = Post.fromJson({
  //     "id": "1",
  //     "date": "31 jul 2025",
  //     "title": "Erros de design que todos devem evitar",
  //     "readTime": "3 minutos",
  //     "createdAt": "2025-07-31T10:00:00Z",
  //     "updatedAt": "2025-08-01T12:30:00Z"
  //   });
  //
  // Esse método facilita a conversão automática dos dados da API
  // para objetos tipados dentro do aplicativo Flutter.
  //
  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json['id'],
    date: json['date'],
    title: json['title'],
    readTime: json['readTime'],
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );
}
