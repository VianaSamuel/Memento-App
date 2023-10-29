import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'sql_helper.dart';

class DebugLoginPage extends StatefulWidget {
  @override
  _DebugLoginPageState createState() => _DebugLoginPageState();
}

class _DebugLoginPageState extends State<DebugLoginPage> {

  _recuperarBancoDados() async {
    var bd = SQLHelper.db();
    return bd;
  }

  _salvarDados(String? nome, String? email, String? senha) async {
    sql.Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {
      "nome" : nome,
      "email" : email,
      "senha" : senha
    };
    int id = await bd.insert("usuarios", dadosUsuario);
    print("Salvo: $id " );
  }

  _listarUsuarios() async{
    sql.Database bd = await _recuperarBancoDados();
    String comando = "SELECT * FROM usuarios";
    List usuarios = await bd.rawQuery(comando);
    for(var usu in usuarios){
      print(" id: "+usu['id'].toString() + "|"
          " conteudo: "+usu['conteudo']+ "|"
          " email: "+usu['email']+ "|"
          " senha: "+usu['senha']+ "|"
          " createdAt: "+ usu['createdAt']);
    }
  }

  _listarUmUsuario(int id) async{
    sql.Database bd = await _recuperarBancoDados();
    List usuarios = await bd.query(
        "usuarios",
        where: "id = ?",
        whereArgs: [id]
    );
    for(var usu in usuarios){
      print(" id: "+usu['id'].toString() + "|"
          " conteudo: "+usu['conteudo']+ "|"
          " email: "+usu['email']+ "|"
          " senha: "+usu['senha']+ "|"
          " createdAt: "+ usu['createdAt']);
    }
  }

  _excluirUsuario(String email) async{
    sql.Database bd = await _recuperarBancoDados();
    int retorno = await bd.delete(
        "usuarios",
        where: "email = ?",  //caracter curinga
        whereArgs: [email]
    );
    print("Itens excluidos: "+retorno.toString());
  }


  _atualizarUsuario(int id, String? nome, String? email, String? senha, bool atualizarDia ) async{
    sql.Database bd = await _recuperarBancoDados();
    Map<String, dynamic> antigosDados = _listarUmUsuario(id);

    Map<String, dynamic> novosDados = {
      "nome" : (nome == null) ? antigosDados['nome']: nome,
      "email" : (email == null) ? antigosDados['email']: email,
      "senha": (senha == null) ? antigosDados['senha']: senha,
      "createdAt": (atualizarDia == false) ? antigosDados['createdAt']: DateTime.now().toString(),
    };

    int retorno = await bd.update(
        "usuarios", novosDados,
        where: "id = ?",
        whereArgs: [id]
    );
    print("Itens atualizados: "+ retorno.toString());
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controllernome = TextEditingController();
    TextEditingController _controlleremail = TextEditingController();
    TextEditingController _controllersenha = TextEditingController();
    TextEditingController _controllerid = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Banco de dados"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: "Digite o nome: ",
              ),
              controller: _controllernome,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Digite o email: ",
              ),
              controller: _controlleremail,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Digite o id: ",
              ),
              controller: _controllerid,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Digite a senha: ",
              ),
              controller: _controllersenha,
            ),
            SizedBox(height: 20,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    child: Text("Salvar um usuário"),
                    onPressed: (){
                          String? nome = (_controllernome.text.isEmpty)
        ? null
        : _controllernome.text;
    String? email = (_controlleremail.text.isEmpty)
        ? null
        : _controlleremail.text;
    String? senha = (_controllersenha.text.isEmpty)
        ? null
        : _controllersenha.text;
                      _salvarDados(nome, email, senha);
                    }
                ),
                ElevatedButton(
                    child: Text("Listar todos usuários"),
                    onPressed: (){
                      _listarUsuarios();
                    }
                ),
                ElevatedButton(
                    child: Text("Listar um usuário"),
                    onPressed: (){
                      _listarUmUsuario(int.parse(_controllerid.text));
                    }
                ),
                ElevatedButton(
                    child: Text("Atualizar um usuário"),
                    onPressed: (){
                                                String? nome = (_controllernome.text.isEmpty)
        ? null
        : _controllernome.text;
    String? email = (_controlleremail.text.isEmpty)
        ? null
        : _controlleremail.text;
    String? senha = (_controllersenha.text.isEmpty)
        ? null
        : _controllersenha.text;
                      _atualizarUsuario(int.parse(_controllerid.text), nome, email, senha, false);
                    }
                ),
                ElevatedButton(
                    child: Text("Excluir usuário"),
                    onPressed: (){
                      _excluirUsuario(_controlleremail.text);
                    }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}