import 'dart:convert';
import 'dart:io';
import 'package:examen_final_perez/models/runners.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/**
 * Provider de runner que nos permitira coger y realizar el CRUD en la aplicacion usando la base de datos.
 */
class RunnerProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final String _baseUrl =
      "runners-54b99-default-rtdb.europe-west1.firebasedatabase.app";
  List<Runner> runners = [];
  late Runner tempRunner;
  Runner? newRunner;
  File? newPicture;

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

  void updateSelectedImage(String path) {
    this.newPicture = File.fromUri(Uri(path: path));

    this.tempRunner.photofinish = path;
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (this.newPicture == null) return null;

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dotg2moxz/image/upload?upload_preset=preset');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', newPicture!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Se ha producido un error');
      print(resp.body);
      return null;
    }

    this.newPicture = null;
    final decodeData = json.decode(resp.body);
    return decodeData['secure_url'];
  }
}
