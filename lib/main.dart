import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/data/services/globals.dart';
import 'app/pages/home.dart';
import 'app/pages/login.dart';

void main() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool _result =
      preferences.getString(Globals().loginPrefName) != null ? true : false;
  Widget _defaultHome = Login();
  if (_result) {
    _defaultHome = Home();
  }
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Odoo Mobile',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: "Montserrat",
      ),
      home: _defaultHome,
      routes: <String, WidgetBuilder>{
        '/home': (_) => Home(),
        '/login': (_) => Login(),
      },
    ),
  );
}
