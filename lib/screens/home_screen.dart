import 'package:examen_final_perez/models/runners.dart';
import 'package:examen_final_perez/providers/providers.dart';
import 'package:examen_final_perez/ui/loading.dart';
import 'package:examen_final_perez/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/**
 * Pantalla principal del programa que mostrara a los corredores en forma de lista utilizando el widget runnerCard donde se muestra
 * la posición y nombre del corredor, de derecha a izquierda se elimina y si se hace click sobre este nos llevara a la pantalla de 
 * detalles para ver los detalles de corredor
 */

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final runnerProvider = Provider.of<RunnerProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
    List<Runner> runners = runnerProvider.runners;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Corredores',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
              onPressed: () async {
                loginProvider.logout();
                Navigator.of(context).pushReplacementNamed('login');
              },
              icon: Icon(
                Icons.power_settings_new_rounded,
                color: Colors.white,
              ))
        ],
      ),
      body: runners.isEmpty
          ? Loading()
          : ListView.builder(
              itemCount: runners.length,
              itemBuilder: ((context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    color: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  child: GestureDetector(
                    child: RunnerCard(runner: runners[index]),
                    onTap: () {
                      runnerProvider.tempRunner = runners[index].copy();
                      Navigator.of(context).pushNamed('details');
                    },
                  ),
                  onDismissed: (direction) {
                    if (runners.length < 2) {
                      runnerProvider.loadRunners();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text('No es pot esborrar tots els elements!')));
                    } else {
                      runnerProvider.deleteRunner(runners[index]);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              '${runnerProvider.runners[index].name} esborrat')));
                    }
                  },
                );
              }),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Cream un runner temporal nou, per diferenciar-lo d'un ja creat,
          // per que aquest no tindrà id encara, i d'aquesta forma sabrem
          // discernir al detailscreen que estam creant un runner nou i no
          // modificant un existent
          runnerProvider.tempRunner = Runner(
              name: '', bibnumber: '', time: '', photofinish: '', position: '');
          Navigator.of(context).pushNamed('details');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
