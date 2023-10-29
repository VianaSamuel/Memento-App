import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> _criaTabelas(sql.Database database) async {
      await database.execute(
      """CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nome TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        senha TEXT NOT NULL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )""");
      await database.execute(
      """CREATE TABLE notas (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        conteudo TEXT NOT NULL,
        usuario INTEGER NOT NULL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )""");
  }

  static Future<void> deletarDataBase() async {
    //sql.deleteDatabase('usuario.db'); // antigo
    sql.deleteDatabase('memento.db');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'memento.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await _criaTabelas(database);
      },
    );
  }

// NOTAS
  static Future<int> adicionarNota(
      String? conteudo, int? usuario) async {
    final db = await SQLHelper.db();
    final dados = {'conteudo': conteudo, 'usuario': usuario};
    int id;
    try {
      id = await db.insert('notas', dados,
          conflictAlgorithm: sql.ConflictAlgorithm.abort);
    } catch (e) {
      id = -1;
    }
    return id;
  }

  static Future<List<Map<String, dynamic>>> pegarNotasDoUsuarioDeHoje(int usuario) async {
    final db = await SQLHelper.db();
    final query = await db.query('notas', where: "usuario = ?", whereArgs: [usuario]);
    List<Map<String, dynamic>> notasDeHoje = [];
    DateTime hoje = DateTime.now();
    for (var element in query) {
      DateTime criacao = DateTime.parse(element['createdAt'].toString());
      if(criacao.day == hoje.day && criacao.month == hoje.month && criacao.year == hoje.year) {
        notasDeHoje.add(element);
      }
    }
    return notasDeHoje;
  }

    static Future<List<Map<String, dynamic>>> pegarNotasDoUsuarioDeUmDia(int usuario, DateTime dia) async {
    final db = await SQLHelper.db();
    final query = await db.query('notas', where: "usuario = ?", whereArgs: [usuario]);
    List<Map<String, dynamic>> notasDoDia = [];
    for (var element in query) {
      DateTime criacao = DateTime.parse(element['createdAt'].toString());
      if(criacao.day == dia.day && criacao.month == dia.month && criacao.year == dia.year) {
        notasDoDia.add(element);
      }
    }
    return notasDoDia;
  }

  static Future<List<Map<String, dynamic>>> pegarNotasDoUsuario(int usuario) async {
    final db = await SQLHelper.db();
    return db.query('notas', where: "usuario = ?", whereArgs: [usuario]);
  }
  
    static Future<Map<String, Object?>> pegarUmaNota(int id) async {
    final db = await SQLHelper.db();
    return (await db.query('notas', where: "id = ?", whereArgs: [id], limit: 1))[0];
  }

  static Future<int> atualizarNota(int id, String conteudo) async {
    final db = await SQLHelper.db();

    final novosDados = {
      'conteudo': conteudo
    };

    final result =
        await db.update('notas', novosDados, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> apagarNota(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("notas", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Erro ao apagar a nota: $err");
    }
  }

// USUARIOS
  static Future<int> adicionarUsuario(
      String? nome, String? email, String? senha) async {
    final db = await SQLHelper.db();
    final dados = {'nome': nome, 'email': email, 'senha': senha};
    int id;
    try {
      id = await db.insert('usuarios', dados,
          conflictAlgorithm: sql.ConflictAlgorithm.abort);
    } catch (e) {
      id = -1;
    }
    return id;
  }

  static Future<List<Map<String, dynamic>>> pegaUsuarios() async {
    final db = await SQLHelper.db();
    return db.query('usuarios', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> pegaUmUsuario(int id) async {
    final db = await SQLHelper.db();
    return db.query('usuarios', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> pegaUmUsuarioPeloEmail(
      String email) async {
    final db = await SQLHelper.db();
    return db.query('usuarios',
        where: "email = ?", whereArgs: [email], limit: 1);
  }

  static Future<int> atualizaUsuario(
      int id, String nome, String email, String senha) async {
    final db = await SQLHelper.db();

    final dados = {
      'nome': nome,
      'email': email,
      'senha': senha,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('usuarios', dados, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> apagaUsuario(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("usuarios", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Erro ao apagar o usuario: $err");
    }
  }
}
