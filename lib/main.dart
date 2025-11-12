import 'package:flutter/material.dart';
import 'theme.dart';
import 'widgets/post_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Posts',
      debugShowCheckedModeBanner: false,
      theme: appTheme, // importa o tema centralizado do theme.dart
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciador de Posts'),
        centerTitle: true,
      ),
      body: const SafeArea(child: PostList()),
    );
  }
}
