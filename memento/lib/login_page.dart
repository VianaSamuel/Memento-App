import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';

  Widget _body() {
    return Column(
      children: [
        SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        //width: 100,
                        //height: 100,
                        child: //Image.asset('assets/images/logo.png'), //Declarar no pubspec
                            Image.network(
                                'https://www.google.com/url?sa=i&url=https%3A%2F%2Flogo.com%2F&psig=AOvVaw2aWhxoh-LSIq0_rSsUUQYb&ust=1698437261885000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCJDujP7BlIIDFQAAAAAdAAAAABAE')),
                    Container(height: 20),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            TextField(
                              onChanged: (text) {
                                email = text;
                              },
                              keyboardType: TextInputType
                                  .emailAddress, //para o teclado ser do tipo que e usado para email
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder()),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              onChanged: (text) {
                                password = text;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  border: OutlineInputBorder()),
                            ),
                            SizedBox(height: 15),
                            ElevatedButton(
                                //style: ElevatedButton.styleFrom( foregroundColor: Colors.black,backgroundColor: Colors.blue) // Para mudar a cor do botao
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/home');
                                },
                                child: Container(
                                    width: double
                                        .infinity, //Para o botao preencher toda a largura
                                    child: Text(
                                      'Entrar',
                                      textAlign: TextAlign.center,
                                    ))),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text('Nao tem uma conta? '),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushReplacementNamed(
                                        '/cadastro'); // Ação a ser realizada quando o botão é clicado
                                  },
                                  child: Text(
                                    'inscreva-se aqui',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.red,
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
      ],
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
