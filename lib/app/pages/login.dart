import 'package:flutter/material.dart';
import 'package:odoo_client/app/data/services/globals.dart';
import 'package:odoo_client/app/data/services/odoo_api.dart';
import 'package:odoo_client/app/data/services/odoo_response.dart';
import 'package:odoo_client/app/data/services/utils.dart';
import 'package:odoo_client/app/pages/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static String odoo_URL;
  String _selectedProtocol = "http";
  String _selectedDb;
  String _email;
  String _pass;
  Globals _globals;
  List<String> _dbList = [];
  List dynamicList = [];
  bool isCorrectURL = false;
  bool isDBFilter = false;
  Odoo _odoo;
  bool isFirstTime = true;
  TextEditingController _urlCtrler = new TextEditingController();
  TextEditingController _emailCtrler = new TextEditingController();
  TextEditingController _passCtrler = new TextEditingController();

  _saveUser(String username) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(_globals.loginPrefName, username);
  }

  _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString("odooUrl") != null) {
        isFirstTime = false;
        _checkURL(prefs.getString("odooUrl"));
        odoo_URL = prefs.getString("odooUrl");
      }
    });
  }

  _login() {
    _email = _emailCtrler.text;
    _pass = _passCtrler.text;
    _odoo = Odoo(url: _globals.url);
    _odoo.authenticate(_email, _pass, _selectedDb).then(
      (OdooResponse auth) {
        if (!auth.hasError()) {
          Map jsonUser = auth.getResult();
          jsonUser["url"] = _globals.url;
          _saveUser(json.encode(jsonUser));
          Navigator.of(context).pushReplacementNamed("/home");
        } else {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext ctxt) {
              return AlertDialog(
                title: Text(
                  "Authentication Failed",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                content: Text(
                  "Invalid Username or Password",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child:
                        Text("Ok", style: TextStyle(fontFamily: "Montserrat")),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            },
          );
        }
      },
    );
  }

  _checkURL(String odooUrl) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _odoo = Odoo(url: odooUrl);
    await _odoo.getDatabases().then(
      (http.Response res) {
        setState(
          () {
            isCorrectURL = true;
            _globals = new Globals(url: odooUrl);
            dynamicList = json.decode(res.body)['result'] as List;
            preferences.setString("odooUrl", odooUrl);
            dynamicList.forEach((db) => _dbList.add(db));
            _selectedDb = _dbList[0];
            if (_dbList.length == 1) {
              isDBFilter = true;
            } else {
              isDBFilter = false;
            }
          },
        );
      },
    ).catchError(
      (e) {
        Utils(context: context).showMessage("Warning", "Invalid URL");
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  @override
  Widget build(BuildContext context) {
    final checkButton = Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: !isCorrectURL
            ? () {
                odoo_URL = _selectedProtocol + "://" + _urlCtrler.text;
                _checkURL(odoo_URL);
              }
            : null,
        padding: EdgeInsets.all(12),
        color: Colors.indigo.shade400,
        child: Text(
          'Connect Odoo Server',
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );

    final protocol = Container(
      width: MediaQuery.of(context).size.width,
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border:
            Border.all(color: Color.fromRGBO(112, 112, 112, 3.0), width: 1.0),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedProtocol,
          onChanged: (String newValue) {
            setState(
              () {
                _selectedProtocol = newValue;
              },
            );
          },
          underline: SizedBox(height: 0.0),
          items: <String>['http', 'https'].map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Montserrat",
                  ),
                ),
              );
            },
          ).toList(),
        ), //DropDownButton
      ),
    );

    final dbs = isDBFilter
        ? SizedBox(height: 0.0)
        : Container(
            width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                    color: Color.fromRGBO(112, 112, 112, 3.0), width: 1.0)),
            child: Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: DropdownButton<String>(
                value: _selectedDb,
                onChanged: (String newValue) {
                  setState(() {
                    _selectedDb = newValue;
                  });
                },
                isExpanded: true,
                underline: SizedBox(height: 0.0),
                hint: Text(
                  "Select Database",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                  ),
                ),
                items: _dbList.map(
                  (db) {
                    return DropdownMenuItem(
                      child: Text(
                        db,
                        style:
                            TextStyle(fontFamily: "Montserrat", fontSize: 18),
                      ),
                      value: db,
                    );
                  },
                ).toList(),
              ),
            ),
          );

    final odooUrl = TextField(
      autofocus: false,
      controller: _urlCtrler,
      decoration: InputDecoration(
        labelText: "Odoo Server URL",
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final email = TextField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailCtrler,
      decoration: InputDecoration(
        labelText: "E-mail",
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final password = TextField(
      controller: _passCtrler,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Password",
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final loginButton = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          _login();
        },
        padding: EdgeInsets.all(12),
        color: Colors.indigo.shade400,
        child: Text(
          'Log In',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: "Montserrat",
            color: Colors.white,
          ),
        ),
      ),
    );

    final checkURLWidget = Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(height: 48.0),
          protocol,
          SizedBox(height: 8.0),
          odooUrl,
          SizedBox(height: 8.0),
          checkButton,
          SizedBox(height: 8.0),
        ],
      ),
    );

    final loginWidget = Container(
      child: Column(
        children: <Widget>[
          dbs,
          SizedBox(height: 8.0),
          email,
          SizedBox(height: 8.0),
          password,
          SizedBox(height: 24.0),
          loginButton
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: "Montserrat",
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          padding: EdgeInsets.all(10.0),
          children: <Widget>[
            isFirstTime ? checkURLWidget : SizedBox(height: 0.0),
            loginWidget,
          ],
        ),
      ),
      floatingActionButton: !isFirstTime
          ? FloatingActionButton(
              child: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Settings()));
              },
            )
          : SizedBox(height: 0.0),
    );
  }
}
