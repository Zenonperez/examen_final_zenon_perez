import 'package:examen_final_perez/providers/providers.dart';
import 'package:examen_final_perez/screens/home_screen.dart';
import 'package:examen_final_perez/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MyAppState());
}

class MyAppState extends StatelessWidget {
  MyAppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [ChangeNotifierProvider(create: (_) => RunnerProvider()),
    ChangeNotifierProvider(create: (_) => LoginProvider())],
    child: MyApp(),
    );
    
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      initialRoute: 'login',
      routes: {
        'home':(_) => HomeScreen(),
        'login': (_) => LoginScreen(),
       // 'details': (_) => DetailScreen(),
      }
    );
  }
}