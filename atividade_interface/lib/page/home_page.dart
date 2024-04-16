import 'dart:math';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
    );
  }

  AppBar _criarAppBar() {
    return AppBar(
      centerTitle: false,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      title: const Text('Atividade Interface'),
      actions: [
        IconButton(
            onPressed: () => setState(() {}), icon: const Icon(Icons.sync))
      ],
    );
  }

  Widget _criarBody() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Card(
                color:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
                child: const SizedBox(
                  height: 80,
                  child: Center(
                    child: Text('Linha 1 | Coluna 1'),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                color:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
                child: const SizedBox(
                  height: 80,
                  child: Center(
                    child: Text('Linha 1 | Coluna 2'),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Card(
                color:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
                child: const SizedBox(
                  height: 80,
                  child: Center(
                    child: Text('Linha 2 | Coluna 1'),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                color:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
                child: const SizedBox(
                  height: 80,
                  child: Center(
                    child: Text('Linha 2 | Coluna 2'),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                color:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
                child: const SizedBox(
                  height: 80,
                  child: Center(
                    child: Text('Linha 2 | Coluna 3'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
