import 'package:flutter/material.dart';
import 'package:memento/meu_snackbar.dart';
import 'package:memento/servicos/autenticacao_servico.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _nameTextEditingController =
      TextEditingController();

  final AutenticacaoServico _autenServico = AutenticacaoServico();

  // se for salvar o endereco -> final TextEditingController _enderecoTextEditingController = TextEditingController();

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
                    width: 200,
                    height: 200,
                  ),
                  //Image.network('https://www.google.com/url?sa=i&url=https%3A%2F%2Flogo.com%2F&psig=AOvVaw2aWhxoh-LSIq0_rSsUUQYb&ust=1698437261885000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCJDujP7BlIIDFQAAAAAdAAAAABAE'),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameTextEditingController,
                            decoration: const InputDecoration(
                                labelText: 'Nome',
                                border: OutlineInputBorder()),
                          ),
                          const SizedBox(height: 10),
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
                                labelText: 'Senha',
                                border: OutlineInputBorder()),
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                              //style: ElevatedButton.styleFrom( foregroundColor: Colors.black,backgroundColor: Colors.blue) // Para mudar a cor do botao
                              onPressed: () async {
                                String nome = _nameTextEditingController.text;
                                String email = _emailTextEditingController.text;
                                String senha =
                                    _passwordTextEditingController.text;
                                _autenServico
                                    .cadastrarUsuario(
                                        nome: nome, senha: senha, email: email)
                                    .then(
                                  (String? erro) {
                                    if (erro != null) {
                                      mostrarSnackBar(
                                          context: context, texto: erro);
                                    } else {
                                      mostrarSnackBar(
                                          context: context,
                                          texto:
                                              "Cadastrado efetuado com sucesso",
                                          isErro: false);
                                      Navigator.of(context)
                                          .pushReplacementNamed('/login');
                                    }
                                  },
                                );
                              },
                              child: Container(
                                  width: double
                                      .infinity, //Para o botao preencher toda a largura
                                  child: const Text(
                                    'Cadastrar',
                                    textAlign: TextAlign.center,
                                  ))),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text('Já possui uma conta? '),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacementNamed(
                                      '/login'); // Ação a ser realizada quando o botão é clicado
                                },
                                child: Text(
                                  'Clique aqui para logar',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
