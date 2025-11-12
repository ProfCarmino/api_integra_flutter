import 'package:flutter/material.dart';

//
// =============================================================
//  CLASSE: PostForm
// =============================================================
//  Essa classe representa um formulário reutilizável para criar
//  ou editar posts (notícias, artigos, publicações etc.).
//
//   É um StatefulWidget, pois precisa controlar estados locais:
//     - Campos de texto (date, title, readTime)
//     - Estados de carregamento (loading)
//     - Exibição de erros
//
//   Responsabilidade única:
//     Exibir e gerenciar os dados de um formulário de post.
//
//   Parâmetros principais:
//     - initial: dados iniciais de um post (usado no modo de edição)
//     - onSubmit: função assíncrona chamada ao clicar em “Salvar”
//     - onCancel: ação executada ao clicar em “Cancelar”
//     - submitLabel: texto do botão principal (padrão: “Salvar”)
//
//  O ciclo de vida do widget é gerenciado por sua classe de estado
//  interna `_PostFormState`, responsável por inicializar controladores,
//  validar campos, e reagir a eventos de envio.
//
class PostForm extends StatefulWidget {
  final Map<String, String>? initial;
  final Future<void> Function(Map<String, String>) onSubmit;
  final VoidCallback? onCancel;
  final String submitLabel;

  const PostForm({
    super.key,
    this.initial,
    required this.onSubmit,
    this.onCancel,
    this.submitLabel = 'Salvar',
  });

  @override
  State<PostForm> createState() => _PostFormState();
}

//
// =============================================================
//  CLASSE DE ESTADO: _PostFormState
// =============================================================
//  Essa classe contém toda a lógica de comportamento do formulário.
//  Ela mantém os controladores de texto, executa validações, e controla
//  o estado visual (por exemplo, mostrar botão “Salvando...” ou erro).
//
//   Responsabilidades principais:
//     1. Controlar o estado dos campos (via TextEditingController);
//     2. Validar o formulário antes do envio;
//     3. Chamar a função externa `onSubmit()`;
//     4. Gerenciar erros e status de carregamento;
//     5. Evitar atualizações após o dispose() (via `mounted`).
//
class _PostFormState extends State<PostForm> {
  // Chave global que permite validar e manipular o estado do <Form>
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto: armazenam e monitoram o conteúdo dos campos.
  // São inicializados com valores vindos de "initial" (modo edição) ou vazios.
  late final TextEditingController date = TextEditingController(
    text: widget.initial?['date'] ?? '',
  );
  late final TextEditingController title = TextEditingController(
    text: widget.initial?['title'] ?? '',
  );
  late final TextEditingController readTime = TextEditingController(
    text: widget.initial?['readTime'] ?? '',
  );

  // Variáveis de estado interno
  bool loading = false; // indica se o formulário está sendo enviado
  String? error; // armazena mensagem de erro (se houver)

  // -------------------------------------------------------------
  // Método dispose()
  // -------------------------------------------------------------
  // Liberamos os controladores de texto da memória quando o widget
  // é removido da árvore (boa prática para evitar memory leaks).
  @override
  void dispose() {
    date.dispose();
    title.dispose();
    readTime.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------
  // Método _handleSubmit()
  // -------------------------------------------------------------
  // Executa a lógica de envio do formulário:
  // 1. Valida os campos
  // 2. Mostra estado de carregamento
  // 3. Chama o callback externo onSubmit()
  // 4. Exibe mensagens de erro, se houver
  // 5. Garante segurança com "mounted" (evita setState após dispose)
  //
  Future<void> _handleSubmit() async {
    // Se o formulário for inválido, interrompe o processo
    if (!_formKey.currentState!.validate()) return;

    // Garante que o widget ainda está ativo antes de atualizar o estado
    if (!mounted) return;
    setState(() => loading = true);

    // Cria um mapa com os valores atuais dos campos (removendo espaços extras)
    final data = {
      'date': date.text.trim(),
      'title': title.text.trim(),
      'readTime': readTime.text.trim(),
    };

    try {
      // Chama o callback externo definido pelo componente pai (ex: PostList)
      await widget.onSubmit(data);

      // Se o widget ainda estiver montado, limpa os campos
      if (mounted) {
        date.clear();
        title.clear();
        readTime.clear();
      }
    } catch (e) {
      // Caso ocorra algum erro, armazena a mensagem no estado
      if (mounted) setState(() => error = e.toString());
    } finally {
      // Finaliza o carregamento (se o widget ainda existir)
      if (mounted) setState(() => loading = false);
    }
  }

  // -------------------------------------------------------------
  // Método build()
  // -------------------------------------------------------------
  // Constrói a interface visual do formulário, composta por:
  // - Três campos de texto (Data, Título, Tempo de leitura)
  // - Mensagem de erro (opcional)
  // - Botões de ação (Cancelar e Salvar)
  //
  // Cada campo é um widget _FormInput separado, com validação automática.
  //
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _FormInput(controller: date, label: 'Data'),
              const SizedBox(height: 12),
              _FormInput(controller: title, label: 'Título'),
              const SizedBox(height: 12),
              _FormInput(controller: readTime, label: 'Tempo de leitura'),

              // Exibe a mensagem de erro, se existir
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              const SizedBox(height: 12),

              // Botões de ação: Cancelar e Salvar
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.onCancel != null)
                    TextButton(
                      onPressed: widget.onCancel,
                      child: const Text('Cancelar'),
                    ),
                  ElevatedButton(
                    onPressed: loading ? null : _handleSubmit,
                    child: Text(loading ? 'Salvando...' : widget.submitLabel),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// =============================================================
//  CLASSE AUXILIAR: _FormInput
// =============================================================
//  Essa classe representa um campo de texto reutilizável dentro do
//  formulário. Ela encapsula a criação de um TextFormField e aplica
//  validação automática.
//
//    Responsabilidade única:
//     Exibir um campo de entrada com rótulo e validação simples.
//
//    Benefícios:
//     - Reutilização (menos código duplicado no formulário principal);
//     - Facilita manutenção e leitura;
//     - Mantém o PostForm mais limpo.
//
class _FormInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const _FormInput({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: (v) => (v == null || v.isEmpty) ? 'Informe $label' : null,
    );
  }
}
