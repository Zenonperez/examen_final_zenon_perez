
import 'package:examen_final_perez/models/runners.dart';
import 'package:flutter/material.dart';

class RunnerCard extends StatelessWidget {
  final Runner runner;
  const RunnerCard({super.key, required this.runner});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(runner.position, 
      style: TextStyle(
        color: Colors.deepOrange, 
        fontWeight: FontWeight.bold,
        fontSize: 20),),
      title: Text(runner.name),
     
      );
  }
}
