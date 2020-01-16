import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_mvvm_demo/viewModels/login_view_model.dart';

class LoginWidget extends StatelessWidget {
  @override
  build(BuildContext context) {
    final provider = Provider.of<LoginViewModel>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: provider.usernameController,
            decoration: InputDecoration(labelText: "username"),
          ),
          TextField(
            controller: provider.passwordController,
            decoration: InputDecoration(labelText: "password"),
          ),
          RaisedButton(
            onPressed: provider.login,
            child: provider.state == 0
                ? Text("login")
                : provider.state == 1
                    ? CircularProgressIndicator()
                    : provider.state == 2
                        ? Icon(Icons.done)
                        : Icon(Icons.cancel),
          ),
        ],
      ),
    );
  }
}
