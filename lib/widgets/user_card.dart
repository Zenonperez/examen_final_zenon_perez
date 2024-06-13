import 'package:examen_final_perez/models/runners.dart';
import 'package:flutter/material.dart';

/**
 * Widget que muestra a los corredores en una lista, que se cargan desde la base de datos, podemos ver la posicion del corredor y el nombre de este
 */
class RunnerCard extends StatelessWidget {
  final Runner runner;
  const RunnerCard({super.key, required this.runner});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        runner.position,
        style: TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.bold,
            fontSize: 20),
      ),
      title: Text(runner.name),
    );
  }
}
