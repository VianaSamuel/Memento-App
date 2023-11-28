import 'package:firebase_auth/firebase_auth.dart';
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
            home: RoteadorTela(),
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

class RoteadorTela extends StatelessWidget {
  const RoteadorTela({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const NotesPage();
        } else {
          return HomePage();
        }
      },
    );
  }
}
