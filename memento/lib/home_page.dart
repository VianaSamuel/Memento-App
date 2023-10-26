import 'package:flutter/material.dart';
import 'package:memento/app_controller.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset('assets/images/logo.pn'),
            ),
            accountName: Text('Marcelo Moreira'),
            accountEmail: Text('@gmail.com'),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Inicio'),
            subtitle: Text('tela de inicio'),
            onTap: () {
              print('Home');
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sair'),
            subtitle: Text('Finalizar sessao'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomSwitch(),
          ),
        ],
      )),
      appBar: AppBar(
        title: Text('HomePage'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          //scrollDirection: Axis.horizontal, //muda o scroll para vertical
          children: [
            Column(children: [
              Text('Contador: $counter'),
            ]),
            Container(height: 10),
            Container(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.black,
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            counter++;
          });
        },
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
