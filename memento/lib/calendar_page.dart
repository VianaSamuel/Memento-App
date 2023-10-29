import 'package:flutter/material.dart';
import 'package:memento/app_controller.dart';
import 'package:memento/login_page.dart';
import 'package:memento/sql_helper.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarPage();
  }
}

class _CalendarPage extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: Scaffold(
            body: Column(
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: const Icon(Icons.person),
                  ),
                  accountName: Text(LoginPage.usuario['nome']),
                  accountEmail: Text(LoginPage.usuario['email']),
                ),
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text('Notas'),
                  subtitle: const Text('suas notas'),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/notes');
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
                )
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
              Text('Calendário'),
            ],
          ),
        ),
        body: TableCalendar(
          headerStyle: const HeaderStyle(titleCentered: true, formatButtonVisible: false),
          currentDay: DateTime.now(),
          onDaySelected: (selectedDay, focusedDay) => setState(() async {
            DateTime hoje = DateTime.now();
            if(selectedDay.day == hoje.day && selectedDay.month == hoje.month && selectedDay.year == hoje.year) {
              final notasDeHoje = await _pegarNotasDeUmDia(hoje);
              for (var element in notasDeHoje) {
                print(element);
              }
              Navigator.of(context).pushReplacementNamed('/notes');
            } else {
              final notasDoDia = await _pegarNotasDeUmDia(selectedDay);
              for (var element in notasDoDia) {
                print(element);
              }
            }
          }),
            firstDay: DateTime.utc(2023, 10, 28), // data inicial do app
            lastDay: DateTime.now(),//.add(const Duration(days: 1)),
            focusedDay: DateTime.now()));
  }

  Future<List<Map<String, dynamic>>> _pegarNotasDeUmDia(DateTime dia) async {
    return SQLHelper.pegarNotasDoUsuarioDeUmDia(LoginPage.usuario['id'], dia);
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
