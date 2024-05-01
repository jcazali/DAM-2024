import 'package:teste/database/database_provider.dart';
import 'package:teste/model/tarefa.dart';

class TarefaDao {
  final dbProvider = DatabaseProvider.instance;

  Future<bool> salvar(Tarefa tarefa) async {
    final db = await dbProvider.database;
    final valores = tarefa.toMap();
    if (tarefa.id == null) {
      tarefa.id = await db.insert(Tarefa.nomeTabela, valores);
      return true;
    } else {
      final registrosAtualizados = await db.update(
        Tarefa.nomeTabela,
        valores,
        where: '${Tarefa.campoId} = ?',
        whereArgs: [tarefa.id],
      );

      return registrosAtualizados > 0;
    }
  }

  Future<bool> remover(int id) async {
    final db = await dbProvider.database;
    final removerRegistro = await db.delete(Tarefa.nomeTabela,
        where: '${Tarefa.campoId} = ?', whereArgs: [id]);

    return removerRegistro > 0;
  }

  Future<List<Tarefa>> Lista({
    String filtro = '',
    String campoOrdenacao = Tarefa.campoId,
    bool usarOrdemDecrescente = false,
  }) async {
    final db = await dbProvider.database;
    String? where;
    if (filtro.isNotEmpty) {
      where = "UPPER(${Tarefa.campoDescricao}) LIKE '${filtro.toUpperCase()}%'";
    }
    var orderBy = campoOrdenacao;

    if (usarOrdemDecrescente) {
      orderBy += 'DESC';
    }

    final resultado = await db.query(
      Tarefa.nomeTabela,
      columns: [
        Tarefa.campoId,
        Tarefa.campoDescricao,
        Tarefa.campoPrazo,
        Tarefa.campoFinalizado
      ],
      where: where,
      orderBy: orderBy,
    );
    return resultado.map((m) => Tarefa.fromMap(m)).toList();
  }
}
