import 'dart:io';
import 'package:flutter/material.dart';
import 'package:odoo_json_rpc_flutter/app/data/services/odoo_api.dart';
import 'app/pages/home.dart';
import 'app/pages/login.dart';
import 'app/utility/strings.dart';
import 'base.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends Base<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.app_title,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: "Montserrat",
      ),
      home: FutureBuilder<Odoo>(
        future: getOdooInstance(),
        builder: (BuildContext context, AsyncSnapshot<Odoo> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return isLoggedIn() ? Home() : Login();
            default:
              return new Container(
                decoration: new BoxDecoration(color: Colors.white),
                child: new Center(
                  child: CircularProgressIndicator(),
                ),
              );
          }
        },
      ),
    );
  }
}
