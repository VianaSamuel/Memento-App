import 'package:memento/sobre.dart';
import 'cadastro.dart';
import 'principal.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Memento Notes'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 150.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: 'Email', fillColor: Colors.black),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => principal()),
                  );
                  // Adicione a lógica de autenticação aqui
                  // Você pode acessar os valores de email e senha usando _emailController.text e _passwordController.text
                },
                child: Text('Entrar'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => cadastro()),
                  );
                  // Navegar para a tela de cadastro
                  // Implemente esta função de acordo com a navegação desejada
                },
                child: Text('Cadastrar'),
              ),
              SizedBox(height: 274.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => sobre()),
                  );
                  // Adicione a lógica de autenticação aqui
                  // Você pode acessar os valores de email e senha usando _emailController.text e _passwordController.text
                },
                child: Text('Sobre'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
