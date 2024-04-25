import 'package:intl/intl.dart';

class Tarefa {
  static const nomeTabela = 'tarefas';
  static const campoId = '_id';
  static const campoDescricao = 'descricao';
  static const campoPrazo = 'prazo';
  static const campoFinalizado = 'finalizado';

  int? id;
  String descricao;
  DateTime? prazo;
  bool finalizado;

  Tarefa(
      {required this.id,
      required this.descricao,
      this.prazo,
      this.finalizado = false});

  String get prazoFormatado {
    if (prazo == null) {
      return '';
    }
    return DateFormat('dd/MM/yyyy').format(prazo!);
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        campoId: id,
        campoDescricao: descricao,
        campoPrazo:
            prazo == null ? null : DateFormat("yyyy-MM-dd").format(prazo!),
        campoFinalizado: finalizado ? 1 : 0
      };

  factory Tarefa.fromMap(Map<String, dynamic> map) => Tarefa(
        id: map[campoId] is int ? map[campoId] : null,
        descricao: map[campoDescricao] is String ? map[campoDescricao] : '',
        prazo: map[campoPrazo] is String
            ? DateFormat('yyyy-MM-dd').parse(map[campoPrazo])
            : null,
        finalizado: map[campoFinalizado] == 1,
      );
}
