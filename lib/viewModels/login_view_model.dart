import 'package:flutter/material.dart';
import 'package:flutter_mvvm_demo/models/login_model.dart';

class LoginViewModel with ChangeNotifier {
  final _model = LoginModel();
  int state = 0; // 0 未请求，1 正在请求， 2 请求成功， 3请求失败
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  login() {
    final data = {
      "username": usernameController.text,
      "password": passwordController.text,
    };

    if (state != 0) return;

    state = 1;
    notifyListeners();

    _model.login(data).listen((v) {
      if (v != 0) {
        state = 3;
        notifyListeners();
        Future.delayed(Duration(seconds: 1), () {
          state = 0;
          notifyListeners();
        });
      } else {
        state = 2;
        notifyListeners();
        Future.delayed(Duration(seconds: 1), () {
          state = 0;
          notifyListeners();
        });
      }
    });
  }
}
