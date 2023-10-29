import 'package:flutter/material.dart';

class sobre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SobrePage(),
      theme:
          ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)),
    );
  }
}

class SobrePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre o Memento APP'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'O aplicativo Memento APP é uma ferramenta digital projetada para ajudar os '
              'usuários a organizar e gerenciar suas atividades diárias, compromissos, tarefas e '
              'eventos de maneira simples. Ele oferece uma interface intuitiva e amigável que '
              'permite aos usuários inserir, editar e visualizar anotações de forma eficiente. ',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'No geral, o aplicativo de agenda pessoal visa simplificar a organização diária dos '
              'usuários, ajudando-os a gerenciar seus compromissos e tarefas de maneira eficaz, '
              'melhorando sua produtividade e reduzindo o estresse relacionado à gestão do '
              'tempo.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
