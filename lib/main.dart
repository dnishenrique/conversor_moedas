import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const api = 'https://api.hgbrasil.com/finance?format=json-cors&key=44e46495';

void main() async{

  runApp(MaterialApp(
    home: Home(),
  ));
}

Future<Map> buscaDados() async{
  http.Response dados = await http.get(api);
  return json.decode(dados.body);
}

class Home extends StatefulWidget {
  @override//digitar stf
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _realController = TextEditingController();
  TextEditingController _dolarController = TextEditingController();
  TextEditingController _euroController = TextEditingController();
  double cotacaoDolar;
  double cotacaoEuro;

  void _realTroca(String real){
    if(real.isEmpty){
      _limpaTudo();
      return;
    }
    double r = double.parse(real);
    _dolarController.text = (r/cotacaoDolar).toStringAsFixed(2);
    _euroController.text = (r/cotacaoEuro).toStringAsFixed(2);
  }
  void _dolarTroca(String dolar){
    if(dolar.isEmpty){
      _limpaTudo();
      return;
    }
    double d = double.parse(dolar);
    _realController.text = (d * cotacaoDolar).toStringAsFixed(2);
    _euroController.text = ((d * cotacaoDolar ) / cotacaoEuro).toStringAsFixed(2);
  }
  void _euroTroca(String euro){
    if(euro.isEmpty){
      _limpaTudo();
      return;
    }
    double e = double.parse(euro);
    _realController.text = (e * cotacaoEuro).toStringAsFixed(1);
    _dolarController.text = ((e * cotacaoEuro)/ cotacaoDolar).toStringAsFixed(2);
  }

  void _limpaTudo(){
    _realController.text = "";
    _dolarController.text = "";
    _euroController.text = "";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversor de Moedas"),
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: buscaDados(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando dados!"),
              );
            default:
              if(snapshot.hasError){
                return Center(
                  child: Text("Erro ao carregar os Dados!")
                );
              }else{
                cotacaoDolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                cotacaoEuro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 140, color: Colors.amber,),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Reais",
                          border: OutlineInputBorder(),
                          prefixText: "R\$ "
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 25),
                        controller: _realController,
                        onChanged: _realTroca,
                      ),
                      Divider(),
                      TextField(
                        decoration: InputDecoration(
                            labelText: "Dolar",
                            border: OutlineInputBorder(),
                            prefixText: "US\$ "
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 25),
                        controller: _dolarController,
                        onChanged: _dolarTroca,
                      ),
                      Divider(),
                      TextField(
                        decoration: InputDecoration(
                            labelText: "Euro",
                            border: OutlineInputBorder(),
                            prefixText: "€ "
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 25),
                        controller: _euroController,
                        onChanged: _euroTroca,
                      ),
                    ],
                  ),
                );
              }
          }
        }
      ),
    );
  }
}
