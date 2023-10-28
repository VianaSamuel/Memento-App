import 'package:flutter/material.dart';
import 'package:memento/app_controller.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(90.0),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                //Image.network('https://www.google.com/url?sa=i&url=https%3A%2F%2Flogo.com%2F&psig=AOvVaw2aWhxoh-LSIq0_rSsUUQYb&ust=1698437261885000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCJDujP7BlIIDFQAAAAAdAAAAABAE'),
                Container(height: 150),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('/login');
                            },
                            child: const SizedBox(
                                width: double.infinity,
                                child: Text(
                                  'Entrar',
                                  textAlign: TextAlign.center,
                                ))),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('/cadastro');
                            },
                            child: const SizedBox(
                                width: double.infinity,
                                child: Text(
                                  'Cadastrar',
                                  textAlign: TextAlign.center,
                                ))),
                      ],
                    ))
              ],
            ))));
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
