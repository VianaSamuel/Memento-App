import 'package:flutter/material.dart';
import 'package:memento/app_controller.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset('assets/images/Logo.jpg'),
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
