import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/data/services/globals.dart';
import 'app/pages/home.dart';
import 'app/pages/login.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool _isFirstTime = false;

  Future<bool> _isFirstTimeMethod() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool _result =
        preferences.getString(Globals().loginPrefName) != null ? true : false;
    return _result;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _isFirstTimeMethod().then((bool val) {
      setState(() {
        _isFirstTime = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Odoo Mobile',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: "Montserrat",
      ),
      home: _isFirstTime ? Home() : Login(),
      routes: <String, WidgetBuilder>{
        '/home': (_) => Home(),
        '/login': (_) => Login(),
      },
    );
  }
}
