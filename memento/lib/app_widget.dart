import 'package:flutter/material.dart';
import 'package:memento/app_controller.dart';
import 'package:memento/cadastro_page.dart';
import 'package:memento/calendar_page.dart';
import 'package:memento/debug_login.dart';
import 'package:memento/debug_notes.dart';
import 'package:memento/home_page.dart';
import 'package:memento/login_page.dart';
import 'package:memento/sobre_page.dart';
import 'package:memento/notes_page.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: AppControler.instance,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.grey,
              brightness: AppControler.instance.isDartTheme
                  ? Brightness.dark
                  : Brightness.light,
            ),
            initialRoute: '/home',
            routes: {
              '/login': (context) => const LoginPage(),
              '/cadastro': (context) => const CadastroPage(),
              '/home': (context) => HomePage(),
              '/notes': (context) => NotesPage(),
              '/sobre': (context) => SobrePage(),
              '/dbglogin': (context) => DebugLoginPage(),
              '/dbgnotes': (context) => DebugNotesPage(),
              '/calendar': (context) => CalendarPage()
            },
          );
        });
  }
}
