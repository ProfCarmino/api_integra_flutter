
#  Exemplo Flutter – Integração com API e Tema Global

Este projeto é um **exemplo didático** em Flutter que demonstra como integrar uma **API REST** a um aplicativo com **formulário, listagem de dados e tema global customizado**.

O código foi desenvolvido passo a passo para ilustrar:
- Comunicação HTTP com backend Node.js;
- CRUD completo (Create, Read, Update, Delete);
- Organização em camadas (UI, modelo e serviço);
- Aplicação de tema visual (`ThemeData`) para cores e tipografia consistentes.


##  Funcionalidades

 Listar posts obtidos via API  
 Criar novos posts através de formulário validado  
 Editar posts existentes (edição inline)  
 Excluir posts com confirmação por diálogo  
 Aplicar tema global com cores e botões personalizados  




##  API utilizada

O aplicativo consome os dados de uma API REST hospedada no servidor:


Base URL: [http://185.137.92.41:3000](http://185.137.92.41:3000)
Endpoints:
GET    /api/posts       → lista de posts
POST   /api/posts       → cria novo post
PUT    /api/posts/:id   → atualiza um post existente
DELETE /api/posts/:id   → exclui um post


As requisições são feitas usando o pacote [`http`](https://pub.dev/packages/http).


##  Tema global (`theme.dart`)

O tema define cores, tipografia e estilos de botões reutilizados em todo o app.

```dart
final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),

  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(Colors.indigo),
    ),
  ),
);
````

Assim, todos os **botões**, **campos de texto** e **títulos** seguem um mesmo padrão visual.

##  Componentes principais

###  `PostForm`

Formulário reutilizável com validação automática (`TextFormField`) para criar ou editar posts.

###  `PostList`

Tela principal: exibe os posts, gerencia as ações de CRUD e mostra formulários inline para edição.

###  `PostsAPI`

Camada de serviço responsável pelas requisições HTTP e conversão de JSON → objetos `Post`.

##  Executar o projeto

1. **Clone o repositório:**

   ```bash
   git clone https://github.com/ProfCarmino/api_integra_flutter.git
   cd api_integra_flutter
   ```

2. **Instale as dependências:**

   ```bash
   flutter pub get
   ```

3. **Execute no emulador ou dispositivo:**

   ```bash
   flutter run
   ```


## Tecnologias utilizadas

* [Flutter](https://flutter.dev) (Material Design 3)
* [Dart](https://dart.dev)
* [HTTP package](https://pub.dev/packages/http)
* Arquitetura modular (camadas: API / Modelo / UI / Tema)


##  Créditos

Desenvolvido por **Prof. Carmino Gomes Jr.**
Exemplo didático para aulas de **Desenvolvimento Flutter e Integração com APIs REST**.
Baseado em práticas modernas de UI/UX e arquitetura limpa.



## Licença

Este projeto é livre para uso educacional e pode ser modificado e redistribuído livremente com os devidos créditos.




