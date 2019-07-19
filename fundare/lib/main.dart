import 'home.dart';
import 'login.dart';
import 'register.dart';
import 'user.dart';
import 'package:flutter/material.dart';

//Main function invocation initiates app
void main() => runApp(FundareApp());

class FundareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'com.fundare.fundareapp',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => HomePage(title: 'Home'),
        '/login': (BuildContext context) => LoginForm(),
        '/register': (BuildContext context) => RegisterForm(),
        '/user': (BuildContext context) => UserPage(),
      },
    );
  }
}
