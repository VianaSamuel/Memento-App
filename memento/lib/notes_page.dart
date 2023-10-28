import 'package:flutter/material.dart';
import 'package:memento/app_controller.dart';
import 'package:memento/login_page.dart';

class NotesPage extends StatefulWidget {
  @override
  State<NotesPage> createState() {
    return NotesPageState();
  }
}

class NotesPageState extends State<NotesPage> {
  final TextEditingController _conteudoTextEditingController =
      TextEditingController();
  List<String> texts = [];
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Scaffold(
          body: Column(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: const Icon(Icons.person),
                ),
                accountName: Text(LoginPage.usuario['nome']),
                accountEmail: Text(LoginPage.usuario['email']),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Inicio'),
                subtitle: const Text('tela de inicio'),
                onTap: () {
                  print('Home');
                },
              ),
              ListTile(
                leading: const Icon(Icons.groups),
                title: const Text('Sobre nos'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/sobre');
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Sair'),
                subtitle: const Text('Finalizar sessao'),
                onTap: () {
                  // deslogar usuario
                  Navigator.of(context).pushReplacementNamed('/home');
                },
              ),
            ],
          ),
          bottomNavigationBar:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text('Modo noturno: '),
            ),
            CustomSwitch(),
          ]),
        ),
      ),
      appBar: AppBar(
        title: const Row(
          children: [
            Text('NotesPage'),
          ],
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: texts.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              selected: index == _selectedIndex,
              title: Text(texts[index]),
              onLongPress: () {
                _selectedIndex = index;
                print("selecionou $index");
              },
              onTap: () {},
            );
          },
        ),
      ),
      floatingActionButton: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: TextField(
                decoration: const InputDecoration(
                    labelText: 'Seu Texto',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black))),
                controller: _conteudoTextEditingController,
              ),
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                texts.add(_conteudoTextEditingController.text);
                _conteudoTextEditingController.clear();
              });
            },
          ),
        ],
      ),
    );
  }
}

class CustomSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: AppControler.instance.isDartTheme,
      onChanged: (value) {
        AppControler.instance.chageTheme();
      },
    );
  }
}
