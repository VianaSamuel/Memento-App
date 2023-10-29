import 'package:flutter/material.dart';
import 'package:memento/app_controller.dart';
import 'package:memento/login_page.dart';
import 'package:memento/sql_helper.dart';

class NotesPage extends StatefulWidget {
  @override
  State<NotesPage> createState() {
    return NotesPageState();
  }
}

class NotesPageState extends State<NotesPage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final TextEditingController _conteudoTextEditingController =
      TextEditingController();

  final ScrollController _controladorScroll = ScrollController();

  List<Map<String, dynamic>> _notas = [];

  bool _estaAtualizando = true;

  void _atualizarNotas() async {
    final data =
        await SQLHelper.pegarNotasDoUsuarioDeHoje(LoginPage.usuario['id']);
    setState(() {
      _notas = data;
      _estaAtualizando = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _atualizarNotas();
  }

  @override
  void dispose() {
    _conteudoTextEditingController.dispose();
    super.dispose();
  }

  void _mostraEdicao(int id) async {
    final notaExistente = _notas.firstWhere((element) => element['id'] == id);
    _conteudoTextEditingController.text = notaExistente['conteudo'];
    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _conteudoTextEditingController,
                    decoration:
                        const InputDecoration(hintText: 'Nome do Produto'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_conteudoTextEditingController.text.isEmpty) {
                        showAlertDialog(
                            context,
                            "Não é possivel criar notas vazias",
                            "Insira um texto em sua nota");
                      } else {
                        await _atualizarNota(id);
                        _conteudoTextEditingController.text = '';
                      }
                      _atualizarNotas();
                      if (!mounted) return;
                      Navigator.of(context).pop();
                    },
                    child: const Text('Editar nota'),
                  )
                ],
              ),
            ));
  }

  Future<void> _adicionarNota() async {
    await SQLHelper.adicionarNota(
        _conteudoTextEditingController.text, LoginPage.usuario['id']);
    _atualizarNotas();
  }

  Future<void> _atualizarNota(int id) async {
    await SQLHelper.atualizarNota(id, _conteudoTextEditingController.text);
    _atualizarNotas();
  }

  void _apagarNota(int id) async {
    await SQLHelper.apagarNota(id);
    _scaffoldMessengerKey.currentState?.showSnackBar(const SnackBar(
      content: Text('Nota apagado!'),
    ));
    _atualizarNotas();
  }

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
                  leading: const Icon(Icons.calendar_month),
                  title: const Text('Calendário'),
                  subtitle: const Text('Acessar notas antigas'),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/calendar');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.groups),
                  title: const Text('Sobre nos'),
                  onTap: () {
                    Navigator.of(context).pushNamed('/sobre');
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
              Text('Suas Notas'),
            ],
          ),
        ),
        body: _estaAtualizando
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                controller: _controladorScroll,
                padding: const EdgeInsets.only(bottom:100),
                shrinkWrap: true,
                itemCount: _notas.length,
                itemBuilder: (context, index) => Card(
                  elevation: 0,
                  margin: const EdgeInsets.all(4),
                  child: ListTile(
                    title: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(_notas[index]['conteudo'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                  )),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Confirmação"),
                                          content: Text(
                                              "Tem certeza que deseja apagar essa nota: \"${_notas[index]['conteudo']}\""),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: const Text("Cancelar")),
                                            TextButton(
                                                onPressed: () {
                                                  _apagarNota(
                                                      _notas[index]['id']);
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Remover")),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _mostraEdicao(_notas[index]['id']),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        floatingActionButton:
        Padding( padding: const EdgeInsets.fromLTRB(30,0,0,0),
          child:
        Material(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          elevation: 1,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10,0,0,10),
                  child: TextField(
                    decoration: const InputDecoration(
                        labelText: 'Nota',
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                    controller: _conteudoTextEditingController,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              FloatingActionButton.small(
                child: const Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.black,
                ),
                onPressed: () {
                  if (_conteudoTextEditingController.text.isNotEmpty) {
                    _adicionarNota();
                    FocusManager.instance.primaryFocus?.unfocus();
                    _controladorScroll.jumpTo(_controladorScroll.position.maxScrollExtent - 150);
                  }
                  _conteudoTextEditingController.clear();
                },
              ),
            ],
          ),
        ),
        )
        );
  }
}

showAlertDialog(BuildContext context, String titulo, String content) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(titulo),
    content: Text(content),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
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
