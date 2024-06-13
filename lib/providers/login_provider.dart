import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier{
  GlobalKey<FormState> loginKey = new GlobalKey<FormState>();

  String user = '';
  String password = '';
  bool rememberMe = false;


  LoginProvider(){
    
    loadUserPreferences();
    
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

bool isValidForm() {
    print('Valor del formulari: ${loginKey.currentState?.validate()}');
    print('$user - $password');
    return loginKey.currentState?.validate() ?? false;
  }

Future<void> loadUserPreferences() async {
  final pref = await SharedPreferences.getInstance();
  rememberMe = pref.getBool('rememberMe') ?? false;
  if (rememberMe){
  user = pref.getString('user') ?? '';
  password = pref.getString('password') ?? '';
  }
  notifyListeners();
}

Future<void> saveUserPreferences() async {
  final pref = await SharedPreferences.getInstance();
  if (rememberMe){
    await pref.setString('user', user);
    await pref.setString('password', password);
    await pref.setBool('rememberMe', rememberMe);
    }else{
      await pref.remove('user');
      user = '';
      await pref.remove('password');
      password = '';
      await pref.remove('rememberMe');
      rememberMe = false;

    }
    notifyListeners();
  }

  Future<void> clearUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (!rememberMe){
    await prefs.remove('user');
    await prefs.remove('password');
    await prefs.remove('rememberMe');
    }
    await prefs.setBool('logginIn', false);
  }

void logout() async {
await clearUserPreferences();
if (!rememberMe){
user = '';
password = '';
}
notifyListeners();
}
}


