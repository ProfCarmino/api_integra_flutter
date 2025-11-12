import 'package:flutter/material.dart';

//
// =============================================================
//  ARQUIVO: theme.dart
// =============================================================
//  Este arquivo define o TEMA GLOBAL da aplicação Flutter.
//  Ele centraliza todas as configurações visuais, garantindo
//  consistência de cores, botões, campos de texto e tipografia.
//
//   Responsabilidade única:
//     Controlar o estilo visual de todos os componentes do app.
//
//   Benefícios:
//     - Reduz repetição de código;
//     - Facilita manutenção e alteração da identidade visual;
//     - Mantém coerência entre telas e widgets.
//
//   Como é aplicado:
//     No MaterialApp (em main.dart):
//       theme: appTheme
//
//     Isso faz com que todas as telas e widgets herdem as
//     configurações definidas aqui.
//
final ThemeData appTheme = ThemeData(
  // -------------------------------------------------------------
  // MATERIAL DESIGN 3
  // -------------------------------------------------------------
  // Ativa o novo sistema de design “Material You” (Material 3),
  // com suporte a temas dinâmicos, bordas arredondadas e animações
  // mais suaves e modernas.
  useMaterial3: true,

  // -------------------------------------------------------------
  // COLOR SCHEME (Esquema de cores)
  // -------------------------------------------------------------
  // Define a paleta principal do aplicativo.
  // O método `fromSeed` cria automaticamente um conjunto
  // de cores harmônicas baseadas em uma cor principal (seedColor).
  //
  // brightness: Brightness.light  indica que o tema é claro.
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.indigo, // cor base do tema
    brightness: Brightness.light,
  ),

  // -------------------------------------------------------------
  // INPUT DECORATION THEME (Campos de texto)
  // -------------------------------------------------------------
  // Define o estilo padrão dos TextField e TextFormField.
  // Isso evita repetir bordas e espaçamentos em cada formulário.
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(), // cria uma borda retangular
    contentPadding: EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 8,
    ), // espaçamento interno entre texto e borda
  ),

  // -------------------------------------------------------------
  // ELEVATED BUTTON THEME (Botão principal  "Criar")
  // -------------------------------------------------------------
  // Configura a aparência dos ElevatedButtons — botões com fundo sólido
  // que representam ações principais (confirmar, salvar, enviar, etc).
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.indigo, // cor de fundo principal
      foregroundColor: Colors.white, // cor do texto e ícones
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // bordas arredondadas
      ),
    ),
  ),

  // -------------------------------------------------------------
  // TEXT BUTTON THEME (Botões secundários  "Editar" e "Excluir")
  // -------------------------------------------------------------
  // Define o estilo global dos TextButtons — botões sem cor de fundo,
  // usados para ações secundárias, como editar, cancelar ou excluir.
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      // Define o estilo do texto (peso e aparência)
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontWeight: FontWeight.w600),
      ),

      // Define a cor do texto conforme o estado do botão
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        // Estado normal  cor padrão (azul indigo)
        if (!states.contains(WidgetState.disabled)) {
          return Colors.indigo;
        }
        // Estado desabilitado  cinza claro
        return Colors.grey;
      }),
    ),
  ),

  // -------------------------------------------------------------
  // TEXT THEME (Tipografia global)
  // -------------------------------------------------------------
  // Define os estilos de texto padrão usados em todo o app.
  // Os nomes (headlineSmall, bodyMedium etc.) seguem a hierarquia
  // tipográfica do Material Design.
  textTheme: const TextTheme(
    headlineSmall: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ), // usado em títulos e seções

    bodyMedium: TextStyle(
      fontSize: 14,
      color: Colors.black87,
    ), // usado em textos comuns
  ),
);
