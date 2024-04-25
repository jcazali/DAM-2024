import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teste/dao/tarefa_dao.dart';
import 'package:teste/model/tarefa.dart';
import 'package:teste/pages/filtro_page.dart';
import 'package:teste/widgets/conteudo_form_dialog.dart';

class ListaTarefaPage extends StatefulWidget {
  @override
  _ListaTarefaPageState createState() => _ListaTarefaPageState();
}

class _ListaTarefaPageState extends State<ListaTarefaPage> {
  final _tarefas = <Tarefa>[];
  final _dao = TarefaDao();

  var _carregando = false;

  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  void _atualizarLista() async {
    setState(() {
      _carregando = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final _campoOrdenacao =
        prefs.getString(FiltroPage.CHAVE_CAMPO_ORDENACAO) ?? Tarefa.campoId;
    final _usarOrdemDecrescente =
        prefs.getBool(FiltroPage.CHAVE_ORDENAR_DECRESCENTE) ?? true;
    final _filtroDescricao =
        prefs.getString(FiltroPage.CHAVE_FILTRO_DESCRICAO) ?? '';

    final tarefas = await _dao.Lista(
      filtro: _filtroDescricao,
      campoOrdenacao: _campoOrdenacao,
      usarOrdemDecrescente: _usarOrdemDecrescente,
    );

    setState(() {
      _tarefas.clear();
      if (tarefas.isNotEmpty) {
        _tarefas.addAll(tarefas);
        _carregando = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _criarAppBar(context),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirForm,
        child: Icon(Icons.add),
        tooltip: 'Nova Tarefa',
      ),
    );
  }

  AppBar _criarAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      title: Text('Tarefas'),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: _abrirFiltro,
          icon: const Icon(Icons.filter_list),
        )
      ],
    );
  }

  Widget _criarBody() {
    if (_carregando) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.center,
            child: CircularProgressIndicator(),
          ),
          Align(
            alignment: AlignmentDirectional.center,
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Carregando suas tarefas..',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      );
    }

    if (_tarefas.isEmpty) {
      return const Center(
        child: Text(
          'Tudo certo por aqui!!!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        final tarefa = _tarefas[index];
        return PopupMenuButton<String>(
          child: ListTile(
            leading: Checkbox(
              value: tarefa.finalizado,
              onChanged: (bool? check) {
                setState(() {
                  tarefa.finalizado = check == true;
                  _dao.salvar(tarefa);
                });
              },
            ),
            title: Text(
              '${tarefa.id} - ${tarefa.descricao}',
              style: TextStyle(
                decoration:
                    tarefa.finalizado ? TextDecoration.lineThrough : null,
                color: tarefa.finalizado ? Colors.grey : null,
              ),
            ),
            subtitle: Text(
              tarefa.prazoFormatado == ''
                  ? 'Sem prazo definido'
                  : 'Prazo - ${tarefa.prazoFormatado}',
              style: TextStyle(
                decoration:
                    tarefa.finalizado ? TextDecoration.lineThrough : null,
                color: tarefa.finalizado ? Colors.grey : null,
              ),
            ),
          ),
          itemBuilder: (BuildContext context) => criarItensMenuPopUp(),
          onSelected: (String valorSelecionado) {
            if (valorSelecionado == ACAO_EDITAR) {
              _abrirForm(tarefaAtual: tarefa);
            } else {
              _excluir(tarefa);
            }
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemCount: _tarefas.length,
    );
  }

  void _abrirFiltro() {
    final navigator = Navigator.of(context);
    navigator.pushNamed(FiltroPage.ROUTE_NAME).then((alterouValor) {
      if (alterouValor == true) {
        _atualizarLista();
      }
    });
  }

  List<PopupMenuEntry<String>> criarItensMenuPopUp() {
    return [
      const PopupMenuItem(
          value: ACAO_EDITAR,
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.black),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Editar'),
              )
            ],
          )),
      const PopupMenuItem(
          value: ACAO_EXCLUIR,
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Excluir'),
              )
            ],
          ))
    ];
  }

  Future _excluir(Tarefa tarefa) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Atenção',
                    style: TextStyle(color: Colors.red),
                  ),
                )
              ],
            ),
            content: const Text('Esse registro será deletado definitivamente!'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (tarefa.id == null) {
                      return;
                    }
                    _dao.remover(tarefa.id!).then((success) {
                      if (success) {
                        _atualizarLista();
                      }
                    });
                  },
                  child: Text('Ok')),
            ],
          );
        });
  }

  void _abrirForm({Tarefa? tarefaAtual}) {
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(tarefaAtual == null
                ? 'Nova tarefa'
                : 'Alterar Tarefa ${tarefaAtual.id}'),
            content: ConteudoFormDialog(key: key, tarefaAtual: tarefaAtual),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  if (key.currentState!.dadosValidados() &&
                      key.currentState != null) {
                    setState(() {
                      final novaTarefa = key.currentState!.novaTarefa;
                      _dao.salvar(novaTarefa).then((success) {
                        if (success) {
                          _atualizarLista();
                        }
                      });
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Salvar'),
              )
            ],
          );
        });
  }
}
