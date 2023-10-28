import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> _criaTabela(sql.Database database) async {
    await database.execute("""CREATE TABLE usuario(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nome TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        senha TEXT NOT NULL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<void> deletarDataBase() async {
    sql.deleteDatabase('usuario.db');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'usuario.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await _criaTabela(database);
      },
    );
  }

  static Future<int> adicionarUsuario(
      String nome, String email, String senha) async {
    final db = await SQLHelper.db();
    final dados = {'nome': nome, 'email': email, 'senha': senha};
    int id;
    try {
      id = await db.insert('usuario', dados,
          conflictAlgorithm: sql.ConflictAlgorithm.abort);
    } catch (e) {
      id = -1;
    }
    return id;
  }

  static Future<List<Map<String, dynamic>>> pegaUsuarios() async {
    final db = await SQLHelper.db();
    return db.query('usuario', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> pegaUmUsuario(int id) async {
    final db = await SQLHelper.db();
    return db.query('usuario', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> pegaUmUsuarioPeloEmail(
      String email) async {
    final db = await SQLHelper.db();
    return db.query('usuario',
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
        await db.update('usuario', dados, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> apagaUsuario(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("usuario", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Erro ao apagar o usuario: $err");
    }
  }
}
