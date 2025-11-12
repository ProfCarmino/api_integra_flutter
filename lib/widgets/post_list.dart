import 'package:flutter/material.dart';
import '../api/posts_api.dart';
import '../models/post.dart';
import 'post_form.dart';

//
// =============================================================
//  CLASSE DE INTERFACE: PostList
// =============================================================
//  Este widget é responsável por exibir a lista de posts e permitir
//  que o usuário crie, edite e exclua posts. Ele é o principal ponto
//  de interação do usuário com os dados de "Post".
//
//   Responsabilidade única:
//     Exibir e gerenciar a interface de listagem e edição de posts.
//
//   Características principais:
//     - Busca dados da API usando `PostsAPI.list()`
//     - Mostra o componente `PostForm` para criar e editar
//     - Exibe mensagens de erro ou carregamento
//     - Oferece ações de exclusão e edição inline.
//
//   Tipo:
//     StatefulWidget  pois a lista de posts e os estados de carregamento
//     e edição variam ao longo do tempo.
//
class PostList extends StatefulWidget {
  const PostList({super.key});

  @override
  State<PostList> createState() => _PostListState();
}

//
// =============================================================
//  CLASSE DE ESTADO: _PostListState
// =============================================================
//  Gerencia o comportamento dinâmico da lista de posts.
//
//   Armazena os estados:
//     - Lista de posts carregados;
//     - Estado de carregamento (loading);
//     - Mensagens de erro (error);
//     - Post em edição (editing).
//
//   Controla o ciclo de vida:
//     - No initState() chama `load()` para buscar os dados assim
//       que o componente é montado.
//
class _PostListState extends State<PostList> {
  // Lista de posts carregados da API
  List<Post> posts = [];

  // Indica se o app está buscando dados da API
  bool loading = true;

  // Armazena uma mensagem de erro, se houver
  String? error;

  // Armazena o post que está sendo editado (ou null)
  Post? editing;

  // -------------------------------------------------------------
  // Ciclo de vida: initState()
  // -------------------------------------------------------------
  // Chamado uma vez quando o widget é inserido na árvore de widgets.
  // Aqui iniciamos o carregamento dos posts assim que o app abre.
  @override
  void initState() {
    super.initState();
    load();
  }

  // -------------------------------------------------------------
  // Método: load()
  // -------------------------------------------------------------
  // Faz uma chamada à API para buscar todos os posts.
  // Mostra a mensagem de carregamento e trata erros de rede.
  Future<void> load() async {
    setState(() => loading = true);
    try {
      posts = await PostsAPI.list(); // busca via API
      error = null; // limpa erros anteriores
    } catch (e) {
      error = 'Falha ao carregar posts';
    } finally {
      setState(() => loading = false);
    }
  }

  // -------------------------------------------------------------
  // Método: createPost()
  // -------------------------------------------------------------
  // Cria um novo post chamando o método `PostsAPI.create()`.
  // Após a criação, atualiza a lista chamando `load()`.
  Future<void> createPost(Map<String, String> payload) async {
    await PostsAPI.create(payload);
    await load();
  }

  // -------------------------------------------------------------
  // Método: updatePost()
  // -------------------------------------------------------------
  // Atualiza um post existente identificado por `id`.
  // Após a atualização, limpa o modo de edição e recarrega a lista.
  Future<void> updatePost(String id, Map<String, String> payload) async {
    await PostsAPI.update(id, payload);
    setState(() => editing = null);
    await load();
  }

  // -------------------------------------------------------------
  // Método: removePost()
  // -------------------------------------------------------------
  // Mostra um diálogo de confirmação antes de excluir um post.
  // Caso o usuário confirme, faz a exclusão e recarrega a lista.
  Future<void> removePost(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir post?'),
        content: const Text('Essa ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    // Se o usuário cancelar, não faz nada.
    if (confirm != true) return;

    // Executa a exclusão via API e recarrega os dados.
    await PostsAPI.remove(id);
    await load();
  }

  // -------------------------------------------------------------
  // Método: build()
  // -------------------------------------------------------------
  // Constrói toda a interface visual da página de posts.
  //
  // Inclui:
  //  - Título "Posts"
  //  - Formulário de criação (`PostForm`)
  //  - Lista de cards com posts existentes
  //  - Estados de carregamento e erro
  //
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título principal da página
          Text('Posts', style: Theme.of(context).textTheme.headlineSmall),

          // Formulário para criar novos posts
          PostForm(onSubmit: createPost, submitLabel: 'Criar'),

          // Estado de carregamento
          if (loading) const Text('Carregando...'),

          // Exibe mensagem de erro, se houver
          if (error != null)
            Text(error!, style: const TextStyle(color: Colors.red)),

          // Se não há posts e não está carregando  mostra mensagem
          if (!loading && error == null && posts.isEmpty)
            const Text('Nenhum post ainda.'),

          // ---------------------------------------------------------
          // Lista de posts
          // ---------------------------------------------------------
          for (final p in posts)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: editing?.id == p.id
                    // Caso esteja editando esse post  mostra o formulário
                    ? PostForm(
                        initial: {
                          'date': p.date,
                          'title': p.title,
                          'readTime': p.readTime,
                        },
                        submitLabel: 'Atualizar',
                        onCancel: () => setState(() => editing = null),
                        onSubmit: (payload) => updatePost(p.id, payload),
                      )
                    // Caso contrário  mostra o card com informações do post
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título do post
                          Text(
                            p.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Metadados (data e tempo de leitura)
                          Text(
                            '${p.date} • ${p.readTime}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),

                          // Botões de ação (Editar / Excluir)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => setState(() => editing = p),
                                child: const Text('Editar'),
                              ),
                              TextButton(
                                onPressed: () => removePost(p.id),
                                child: const Text('Excluir'),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
