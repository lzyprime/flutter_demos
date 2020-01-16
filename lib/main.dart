import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_mvvm_demo/views/login_widget.dart';
import 'package:flutter_mvvm_demo/viewModels/login_view_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter mvvm Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (_) => LoginViewModel(),
        child: LoginWidget(),
      ),
    );
  }
}
