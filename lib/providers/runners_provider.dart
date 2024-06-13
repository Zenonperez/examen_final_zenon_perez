import 'dart:convert';

import 'package:examen_final_perez/models/runners.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RunnerProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final String _baseUrl = "examen-practic-sim-default-rtdb.europe-west1.firebasedatabase.app";
  List<Runner> runners = [];
  late Runner tempRunner;
  Runner? newRunner;

  RunnerProvider() {
    this.loadRunners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  loadRunners() async {
    runners.clear();
    final url = Uri.https(_baseUrl, 'corredors.json');
    final response = await http.get(url);
    final Map<String, dynamic> runnersMap = json.decode(response.body);

    runnersMap.forEach((key, value) {
      final auxRunner = Runner.fromMap(value);
      auxRunner.id = key;
      runners.add(auxRunner);
    });

    notifyListeners();
  }

  Future saveOrCreateRunner() async {
    if (tempRunner.id == null) {
      //Cream l'runner
      await this.createRunner();
    } else {
      //Actualitzam l'runner
      await this.updateRunner();
    }
    loadRunners();
  }

  updateRunner() async {
    final url = Uri.https(_baseUrl, 'corredors/${tempRunner.id}.json');
    final response = await http.put(url, body: tempRunner.toJson());
    final decodedData = response.body;
  }

  createRunner() async {
    final url = Uri.https(_baseUrl, 'corredors.json');
    final response = await http.post(url, body: tempRunner.toJson());
    final decodedData = json.decode(response.body);
  }

  deleteRunner(Runner runner) async {
    final url = Uri.https(_baseUrl, 'corredors/${runner.id}.json');
    final response = await http.delete(url);
    final decodedData = json.decode(response.body);
    print(decodedData);
    loadRunners();
  }
}
