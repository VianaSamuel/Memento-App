import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:memento/app_controller.dart';
import 'package:memento/servicos/autenticacao_servico.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() {
    return NotesPageState();
  }
}

class NotesPageState extends State<NotesPage> {
  final TextEditingController _conteudoTextEditingController =
      TextEditingController();

  final ScrollController _controladorScroll = ScrollController();

  final List<Map<String, dynamic>> _notas = [];

  bool _estaAtualizando = true;

  final AutenticacaoServico _autenServico = AutenticacaoServico();

  @override
  void initState() {
    super.initState();
    // Ao iniciar o widget, carregue as notas do Firebase
    _carregarNotasDoFirebase();
  }

  void _carregarNotasDoFirebase() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref = FirebaseDatabase.instance.ref('users/$userId');

    // Adicione um listener para receber as atualizações do banco de dados
    ref.onValue.listen((event) {
      // Limpe a lista existente de notas
      _notas.clear();

      // Obtenha os dados do snapshot
      var data = event.snapshot.value;

      // Se houver dados e for do tipo Map, adicione-os à lista de notas
      if (data is Map) {
        data.forEach((key, value) {
          _notas.add({"id": key, "conteudo": value});
        });
      }

      setState(() {
        _estaAtualizando = false;
      });
    });
  }

  void _removerNota(String notaId) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('users/$userId/$notaId');

    ref.remove();
    // Atualize a lista local para refletir a remoção
    _notas.removeWhere((nota) => nota["id"] == notaId);
  }

  void _mostrarDialogoExclusao(
      BuildContext context, String notaId, String conteudo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmação"),
          content:
              Text("Tem certeza que deseja apagar essa nota: \"$conteudo\""),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                _removerNota(notaId);
                Navigator.of(context).pop();
              },
              child: const Text("Remover"),
            ),
          ],
        );
      },
    );
  }

  void _editarNota(BuildContext context, String notaId, String conteudo) {
    TextEditingController _conteudoEditController = TextEditingController();
    _conteudoEditController.text = conteudo;

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
              controller: _conteudoEditController,
              decoration: const InputDecoration(hintText: 'Editar Nota'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_conteudoEditController.text.isEmpty) {
                  showAlertDialog(
                    context,
                    "Não é possível salvar uma nota vazia",
                    "Insira um texto na sua nota",
                  );
                } else {
                  // Atualize a nota no banco de dados
                  String userId = FirebaseAuth.instance.currentUser!.uid;
                  DatabaseReference ref =
                      FirebaseDatabase.instance.ref('users/$userId/$notaId');
                  await ref.set(_conteudoEditController.text);

                  // Atualize a lista local para refletir a edição
                  int notaIndex =
                      _notas.indexWhere((nota) => nota["id"] == notaId);
                  if (notaIndex != -1) {
                    setState(() {
                      _notas[notaIndex]["conteudo"] =
                          _conteudoEditController.text;
                    });
                  }
                }

                Navigator.of(context).pop(); // Feche o modal
              },
              child: const Text('Salvar edição'),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
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
                  accountName: currentUser != null
                      ? Text(currentUser.displayName ?? '')
                      : const Text(
                          "Nome do usuario"), //LoginPage.usuario['nome']
                  accountEmail: currentUser != null
                      ? Text(currentUser.email ?? '')
                      : const Text("Email"), //LoginPage.usuario['email']
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
                    _autenServico.deslogar();
                    //DebugAuth().authStateChanges(); // Este metodo verfica se o usuario esta logado
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
                padding: const EdgeInsets.only(bottom: 100),
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
                                    _mostrarDialogoExclusao(
                                      context,
                                      _notas[index]['id'],
                                      _notas[index]['conteudo'],
                                    );
                                  },
                                ),
                                IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      _editarNota(
                                        context,
                                        _notas[index]['id'],
                                        _notas[index]['conteudo'],
                                      );
                                    }),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
          child: Material(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            elevation: 1,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
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
                    String userId = currentUser!.uid;
                    DatabaseReference ref =
                        FirebaseDatabase.instance.ref('users/$userId');
                    DatabaseReference newPostRef = ref.push();
                    String notaTexto = _conteudoTextEditingController.text;
                    newPostRef.set(notaTexto);

                    _conteudoTextEditingController.clear();
                  },
                ),
              ],
            ),
          ),
        ));
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
