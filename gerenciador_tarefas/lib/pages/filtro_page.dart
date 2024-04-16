import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teste/model/tarefa.dart';

class FiltroPage extends StatefulWidget {
  static const ROUTE_NAME = '/filtro';
  static const CHAVE_CAMPO_ORDENACAO = 'campoOrdenacao';
  static const CHAVE_ORDENAR_DECRESCENTE = 'usarOrdemDecrescente';
  static const CHAVE_FILTRO_DESCRICAO = 'filtroDescricao';

  @override
  _FiltroPageState createState() => _FiltroPageState();
}

@override
class _FiltroPageState extends State<FiltroPage> {
  final camposParaOrdenacao = {
    Tarefa.campoId: 'Código',
    Tarefa.campoDescricao: 'Descrição',
    Tarefa.campoPrazo: 'Prazo'
  };

  late final SharedPreferencesprefs;
  final _descricaoControler = TextEditingController();
  String _campoOrdenacao = Tarefa.campoId;
  bool _usarOrdemDecresente = false;
  bool _alterouValores = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: const Text('Filtro e Ordenação'),
        ),
        body: _criarBody(),
      ),
    );
  }

  Widget _criarBody() {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10, top: 10),
          child: Text('Campos para ordenação'),
        ),
        for (final campo in camposParaOrdenacao.keys)
          Row(
            children: [
              Radio(
                value: campo,
                groupValue: _campoOrdenacao,
                onChanged: _onCampoOrdenacaoChanged,
              ),
              Text(camposParaOrdenacao[campo] ?? ''),
            ],
          ),
        const Divider(),
        Row(
          children: [
            Checkbox(
              value: _usarOrdemDecresente,
              onChanged: null,
            ),
            const Text('Usar ordem decresente')
          ],
        ),
        const Divider(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            decoration: InputDecoration(labelText: 'A descrição começa com:'),
          ),
        ),
      ],
    );
  }

  void _onCampoOrdenacaoChanged(String? valor) {
    prefs.setString(FiltroPage.CHAVE_CAMPO_ORDENACAO, valor ?? '');
    _alterouValores = true;

    setState(() {
      _campoOrdenacao = valor ?? '';
    });
  }
}
