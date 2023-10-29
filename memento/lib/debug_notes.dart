import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'sql_helper.dart';

class DebugNotesPage extends StatefulWidget {
  @override
  _DebugNotesPageState createState() => _DebugNotesPageState();
}

class _DebugNotesPageState extends State<DebugNotesPage> {

  _recuperarBancoDados() async {
    var bd = SQLHelper.db();
    return bd;
  }

  _salvarDados(String? conteudo, String? usuario) async {
    sql.Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {
      "conteudo" : conteudo,
      "usuario" : usuario,
    };
    int id = await bd.insert("notas", dadosUsuario);
    print("Salvo: $id " );
  }

  _listarNotas() async{
    sql.Database bd = await _recuperarBancoDados();
    String comando = "SELECT * FROM notas";
    List notas = await bd.rawQuery(comando);
    for(var usu in notas){
      print(" id: "+usu['id'].toString() + "|"
          " conteudo: "+usu['conteudo']+ "|"
          " usuario: "+usu['usuario'].toString()+ "|"
          " createdAt: "+ usu['createdAt']);
    }
  }

  _listarUmaNota(int id) async{
    sql.Database bd = await _recuperarBancoDados();
    List usuarios = await bd.query(
        "notas",
        where: "id = ?",
        whereArgs: [id]
    );
    for(var usu in usuarios){
      print(" id: "+usu['id'].toString() + "|"
          " conteudo: "+usu['conteudo']+ "|"
          " usuario: "+usu['usuario']+ "|"
          " createdAt: "+ usu['createdAt']);
    }
  }

  _excluirNota(id) async{
    sql.Database bd = await _recuperarBancoDados();
    int retorno = await bd.delete(
        "notas",
        where: "id = ?",  //caracter curinga
        whereArgs: [id]
    );
    print("Itens excluidos: "+retorno.toString());
  }

    _excluirNotas(String usuario) async{
    sql.Database bd = await _recuperarBancoDados();
    int retorno = await bd.delete(
        "notas",
        where: "usuario = ?",  //caracter curinga
        whereArgs: [usuario]
    );
    print("Itens excluidos: "+retorno.toString());
  }


  _atualizarUsuario(int id, String? conteudo, String? usuario, bool atualizarDia ) async{
    sql.Database bd = await _recuperarBancoDados();
    Map<String, dynamic> antigosDados = _listarUmaNota(id);

    Map<String, dynamic> novosDados = {
      "conteudo" : (conteudo == null) ? antigosDados['conteudo']: conteudo,
      "usuario" : (usuario == null) ? antigosDados['usuario']: usuario,
      "createdAt": (atualizarDia == false) ? antigosDados['createdAt']: DateTime.now().toString(),
    };

    int retorno = await bd.update(
        "notas", novosDados,
        where: "id = ?",
        whereArgs: [id]
    );
    print("Itens atualizados: "+ retorno.toString());
  }


  @override
  Widget build(BuildContext context) {
    TextEditingController _controllerconteudo = TextEditingController();
    TextEditingController _controllerusuario = TextEditingController();
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
                labelText: "Digite o conteudo: ",
              ),
              controller: _controllerconteudo,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Digite o usuario: ",
              ),
              controller: _controllerusuario,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Digite o id: ",
              ),
              controller: _controllerid,
            ),
            SizedBox(height: 20,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    child: Text("Salvar um nota"),
                    onPressed: (){
                          String? conteudo = (_controllerconteudo.text.isEmpty)
        ? null
        : _controllerconteudo.text;
    String? usuario = (_controllerusuario.text.isEmpty)
        ? null
        : _controllerusuario.text;
                      _salvarDados(conteudo, usuario);
                    }
                ),
                ElevatedButton(
                    child: Text("Listar todos notas"),
                    onPressed: (){
                      _listarNotas();
                    }
                ),
                ElevatedButton(
                    child: Text("Listar um nota"),
                    onPressed: (){
                      _listarUmaNota(int.parse(_controllerid.text));
                    }
                ),
                ElevatedButton(
                    child: Text("Atualizar um nota"),
                    onPressed: (){
                                                String? conteudo = (_controllerconteudo.text.isEmpty)
        ? null
        : _controllerconteudo.text;
    String? usuario = (_controllerusuario.text.isEmpty)
        ? null
        : _controllerusuario.text;
                _atualizarUsuario(int.parse(_controllerid.text), conteudo, usuario, false);
                    }
                ),
                ElevatedButton(
                    child: Text("Excluir nota"),
                    onPressed: (){
                      _excluirNota(int.parse(_controllerid.text));
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