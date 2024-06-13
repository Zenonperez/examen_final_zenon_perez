import 'package:examen_final_perez/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    return Scaffold(
        backgroundColor: Colors.blue,
        body: SingleChildScrollView(
            child: Stack(children: [
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Icon(
                Icons.supervised_user_circle_sharp,
                color: Colors.white,
                size: 100,
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LoginForm(),
                  SizedBox(height: 30),
                  MaterialButton(
                      color: Colors.purple,
                      onPressed: () async {
                        loginProvider.isLoading = true;
                        if (loginProvider.isValidForm()) {
                          await loginProvider.saveUserPreferences();
                          Navigator.of(context).pushReplacementNamed('home');
                        }
                        loginProvider.isLoading = false;
                      },
                      child: Text(
                        'Connect',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ))
                ],
              )),
        ])));
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    return Form(
      key: loginProvider.loginKey,
      child: Column(
        children: [
          Text(
            'Login',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 40,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'User:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          TextFormField(
              autocorrect: false,
              initialValue: loginProvider.user,
              onChanged: (value) => loginProvider.user = value,
              validator: (value) {
                if (value == null || value.length < 4) {
                  return 'The user name must have at least 4 characters';
                }
              }),
          SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Password:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          TextFormField(
              autocorrect: false,
              obscureText: true,
              initialValue: loginProvider.password,
              onChanged: (value) => loginProvider.password = value,
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'The password must have at least 6 charactes';
                }
              }),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Checkbox(
                  value: loginProvider.rememberMe,
                  onChanged: (value) {
                    loginProvider.rememberMe = value ?? false;
                    loginProvider.notifyListeners();
                  }),
              Text('Remember me')
            ],
          )
        ],
      ),
    );
  }
}