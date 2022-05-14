import 'package:flutter/material.dart';
import 'package:login_tutorial/controllers/login_controller.dart';
import 'package:login_tutorial/login/login_page.dart';
import 'package:provider/provider.dart';


class Login extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginController(),
          child: LoginPage(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(),
      ),
    );
  }
}
