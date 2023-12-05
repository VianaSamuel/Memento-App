import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:memento/app_controller.dart';
import 'package:memento/servicos/autenticacao_servico.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CalendarPage();
  }
}

class _CalendarPage extends State<CalendarPage> {
  final AutenticacaoServico _autenServico = AutenticacaoServico();
  final List<Map<String, dynamic>> _notas = [];

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
                  borderRadius: BorderRadius.circular(100),
                  child: const Icon(Icons.person),
                ),
                accountName: currentUser != null
                    ? Text(currentUser.displayName ?? '')
                    : const Text("Nome do usuario"),
                accountEmail: currentUser != null
                    ? Text(currentUser.email ?? '')
                    : const Text("Email"),
              ),
              ListTile(
                leading: const Icon(
                  Icons.list,
                  color: Colors.teal,
                ),
                title: const Text('Notas'),
                subtitle: const Text('suas notas'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/notes');
                },
              ),
              ListTile(
                leading: const Icon(Icons.groups),
                title: const Text('Sobre nós'),
                onTap: () {
                  Navigator.of(context).pushNamed('/sobre');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                ),
                title: const Text('Sair'),
                subtitle: const Text('Finalizar sessao'),
                onTap: () {
                  // deslogar usuario
                  _autenServico.deslogar();
                  Navigator.of(context).pushReplacementNamed('/home');
                },
              )
            ],
          ),
          bottomNavigationBar:
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
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
        headerStyle:
            const HeaderStyle(titleCentered: true, formatButtonVisible: false),
        currentDay: DateTime.now(),
        onDaySelected: (selectedDay, focusedDay) => setState(
          () {
            _handleDaySelected(selectedDay);
          },
        ),
        firstDay: DateTime.utc(2023, 10, 28), // data inicial do app
        lastDay: DateTime.now(), //.add(const Duration(days: 1)),
        focusedDay: DateTime.now(),
        calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.teal, // Defina a cor desejada para o dia focado
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Future<void> _handleDaySelected(DateTime selectedDay) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String formattedDate =
        "${selectedDay.day}:${selectedDay.month}:${selectedDay.year}";
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('users/$userId/$formattedDate');
    ref.onValue.listen((event) {
      var data = event.snapshot.value;
      List<Widget> contentWidgets = [];
      if (data is Map) {
        data.forEach((key, value) {
          _notas.add({"id": key, "conteudo": value});
          contentWidgets.add(
            ListTile(
              title: Text(value),
            ),
          );
        });
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Notas"),
            content: Column(
              children: contentWidgets,
            ),
            //Eu quero colocar todos os conteudos em uma lista aqui
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Voltar"),
              ),
            ],
          );
        },
      );
    });
    // Adicione qualquer lógica assíncrona aqui, se necessário
  }
}

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({super.key});

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
