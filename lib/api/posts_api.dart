import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

//
// =============================================================
//  CLASSE DE SERVIÇO: PostsAPI
// =============================================================
//  Essa classe concentra todas as operações de comunicação entre
//  o aplicativo Flutter e a API REST hospedada no servidor.
//
//   Responsabilidade única:
//     Fornecer métodos para realizar operações CRUD (Create, Read,
//     Update, Delete) sobre a entidade "Post".
//
//   Padrão de projeto:
//     Implementa o padrão “Service” ou “Data Provider”, isolando
//     a lógica de rede da camada de interface (UI).
//
//   Benefícios dessa abordagem:
//     - Reutilização de código em diferentes partes do app;
//     - Facilita testes e manutenção;
//     - Mantém a camada de UI desacoplada da lógica HTTP.
//
class PostsAPI {
  // -------------------------------------------------------------
  // ENDEREÇO BASE DA API
  // -------------------------------------------------------------
  // O endereço IP + porta do servidor que fornece os endpoints.
  // Este valor é usado como base para construir URLs completas.
  static const String baseUrl = 'https://back.standclass.com.br/';

  // -------------------------------------------------------------
  // MÉTODO: list()
  // -------------------------------------------------------------
  //  Tipo: Leitura (GET)
  //  Função:
  //     Faz uma requisição HTTP GET para buscar todos os posts.
  //     Converte o JSON retornado pela API em uma lista de objetos
  //     Post, usando o método Post.fromJson().
  //
  //  Endpoint chamado:
  //     GET http://185.137.92.41:3000/api/posts
  //
  //  Retorno:
  //     Future<List<Post>> — uma lista de posts.
  //
  static Future<List<Post>> list() async {
    final res = await http.get(Uri.parse('$baseUrl/api/posts'));

    // Caso o servidor não retorne código 200 (sucesso),
    // lançamos uma exceção para que a UI possa tratar o erro.
    if (res.statusCode != 200) throw Exception('Erro ao carregar posts');

    // Decodifica o corpo da resposta JSON em uma lista dinâmica.
    final List data = json.decode(res.body);

    // Mapeia cada elemento JSON para um objeto Post fortemente tipado.
    return data.map((e) => Post.fromJson(e)).toList();
  }

  // -------------------------------------------------------------
  // MÉTODO: create()
  // -------------------------------------------------------------
  //  Tipo: Criação (POST)
  //  Função:
  //     Envia uma requisição HTTP POST para criar um novo post.
  //     Os dados são enviados no corpo da requisição em formato JSON.
  //
  //  Endpoint chamado:
  //     POST http://185.137.92.41:3000/api/posts
  //
  //  Parâmetro:
  //     payload — mapa com os campos "date", "title" e "readTime".
  //
  //  Retorno:
  //     Future<void> — operação assíncrona sem retorno direto.
  //
  static Future<void> create(Map<String, String> payload) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/posts'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    // Verifica se o status HTTP indica sucesso (200 ou 201).
    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception('Erro ao criar post');
    }
  }

  // -------------------------------------------------------------
  // MÉTODO: update()
  // -------------------------------------------------------------
  //  Tipo: Atualização (PUT)
  //  Função:
  //     Atualiza um post existente no servidor, identificado por "id".
  //     Envia os dados modificados em formato JSON no corpo da requisição.
  //
  //  Endpoint chamado:
  //     PUT http://185.137.92.41:3000/api/posts/{id}
  //
  //  Parâmetros:
  //     - id: identificador do post que será atualizado.
  //     - payload: dados novos a serem gravados.
  //
  //  Retorno:
  //     Future<void> — operação assíncrona sem retorno direto.
  //
  static Future<void> update(String id, Map<String, String> payload) async {
    final res = await http.put(
      Uri.parse('$baseUrl/api/posts/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    if (res.statusCode != 200) throw Exception('Erro ao atualizar post');
  }

  // -------------------------------------------------------------
  // MÉTODO: remove()
  // -------------------------------------------------------------
  //  Tipo: Exclusão (DELETE)
  //  Função:
  //     Remove permanentemente um post existente no servidor.
  //
  //  Endpoint chamado:
  //     DELETE http://185.137.92.41:3000/api/posts/{id}
  //
  //  Parâmetro:
  //     id — identificador do post a ser excluído.
  //
  //  Retorno:
  //     Future<void> — operação assíncrona sem retorno direto.
  //
  static Future<void> remove(String id) async {
    final res = await http.delete(Uri.parse('$baseUrl/api/posts/$id'));

    // Alguns servidores retornam 204 (sem conteúdo) ao excluir com sucesso.
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Erro ao excluir post');
    }
  }
}
