import 'package:flutter/material.dart';
import 'package:memento/meu_snackbar.dart';
import 'package:memento/servicos/autenticacao_servico.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static Map<String, dynamic> usuario = Map<String, dynamic>();

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final AutenticacaoServico _autenServico = AutenticacaoServico();

  Widget _body() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    'assets/images/logo-transparent.png',
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _emailTextEditingController,
                            keyboardType: TextInputType
                                .emailAddress, //para o teclado ser do tipo que e usado para email
                            decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder()),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _passwordTextEditingController,
                            obscureText: true,
                            decoration: const InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder()),
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                              //style: ElevatedButton.styleFrom( foregroundColor: Colors.black,backgroundColor: Colors.blue) // Para mudar a cor do botao
                              onPressed: () async {
                                String email = _emailTextEditingController.text;
                                String senha =
                                    _passwordTextEditingController.text;
                                _autenServico
                                    .logarUsuarios(email: email, senha: senha)
                                    .then((String? erro) {
                                  if (erro != null) {
                                    mostrarSnackBar(
                                        context: context, texto: erro);
                                  } else {
                                    Navigator.of(context)
                                        .pushReplacementNamed('/notes');
                                  }
                                });
                              },
                              child: Container(
                                  width: double
                                      .infinity, //Para o botao preencher toda a largura
                                  child: const Text(
                                    'Entrar',
                                    textAlign: TextAlign.center,
                                  ))),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text('Nao tem uma conta? '),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacementNamed(
                                      '/cadastro'); // Ação a ser realizada quando o botão é clicado
                                },
                                child: Text(
                                  'Inscreva-se aqui',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //Veficar esse const
        body: Stack(
      children: [
        _body(),
      ],
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
