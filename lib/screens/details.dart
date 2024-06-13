import 'dart:io';

import 'package:examen_final_perez/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/runners.dart';

/**
 * Screen de details que nos mostrara los datos de los corredores y poder editarlos y guardarlos.
 */
class DetailScreen extends StatelessWidget {
  DetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final runnerForm = Provider.of<RunnerProvider>(context, listen: false);
    Runner tempRunner = runnerForm.tempRunner;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Runner Details'),
        ),
        body: SingleChildScrollView(child: _RunnerForm()),
        backgroundColor: Colors.amber[50],
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (runnerForm.isValidForm()) {
              final String? imageUrl = await runnerForm.uploadImage();
              if (imageUrl != null) {
                tempRunner.photofinish = imageUrl;
              }
              if (tempRunner.photofinish != '') {
                runnerForm.saveOrCreateRunner();
                Navigator.of(context).pop();
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content:
                          Text('No puedes crear a un corredor su foto finish'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            }
          },
          child: const Icon(Icons.save),
        ));
  }
}

class _RunnerForm extends StatelessWidget {
  const _RunnerForm({super.key});

  @override
  Widget build(BuildContext context) {
    final runnerForm = Provider.of<RunnerProvider>(context);
    Runner tempRunner = runnerForm.tempRunner;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: Form(
            key: runnerForm.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Text("Cambiar imagen: (Es obligatoria)"),
                Positioned(
                    child: IconButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    // Tambien esta comentada aqui la función de usar la foto de la galeria del telefono.
                    //final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.camera);
                    //print(photo!.path);
                    //Aqui se cambiara la imagen del producto de manera temporal a no ser que se pulse guardar.
                    runnerForm.updateSelectedImage(image!.path);
                  },
                  icon: Icon(
                    Icons.photo,
                    size: 20,
                  ),
                )),
                Container(
                  width: double.infinity,
                  height: 450,
                  child: Opacity(
                      opacity: 0.8,
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25)),
                          child: getImage(tempRunner.photofinish))),
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Name:'),
                ),
                TextFormField(
                  initialValue: tempRunner.name,
                  onChanged: ((value) => tempRunner.name = value),
                  validator: (value) {
                    if (value == null || value.length < 1) {
                      return 'There must be a name value';
                    }
                  },
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Time:'),
                ),
                TextFormField(
                  initialValue: tempRunner.time,
                  onChanged: ((value) => tempRunner.time = value),
                  validator: (value) {
                    if (value == null || value.length < 1) {
                      return 'There must be a time value';
                    }
                  },
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Position:'),
                ),
                TextFormField(
                  initialValue: tempRunner.position,
                  maxLines: null,
                  onChanged: ((value) => tempRunner.position = value),
                  validator: (value) {
                    if (value == null || value.length < 1) {
                      return 'There must be a position value';
                    }
                  },
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Bibnumer:'),
                ),
                TextFormField(
                  initialValue: tempRunner.bibnumber,
                  maxLines: null,
                  onChanged: ((value) => tempRunner.bibnumber = value),
                  validator: (value) {
                    if (value == null || value.length < 1) {
                      return 'There must be a bibnumber value';
                    }
                  },
                ),
              ],
            )),
      ),
    );
  }

  Widget getImage(String? picture) {
    if (picture == null)
      return Image(
        image: AssetImage('assets/no-image.jpg'),
        fit: BoxFit.cover,
      );

    if (picture.startsWith('http'))
      return FadeInImage(
          placeholder: AssetImage('assets/loading.gif'),
          image: NetworkImage(picture),
          fit: BoxFit.cover);

    return Image.file(File(picture), fit: BoxFit.cover);
  }
}
