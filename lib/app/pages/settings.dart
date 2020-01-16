import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:odoo_client/app/data/services/odoo_api.dart';
import 'package:odoo_client/app/utility/constant.dart';
import 'package:odoo_client/app/utility/strings.dart';
import 'package:odoo_client/base.dart';

import 'login.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends Base<Settings> {
  TextEditingController _urlCtrler = new TextEditingController();
  String odooURL = "";

  @override
  void initState() {
    super.initState();
    getOdooInstance().then((odoo) {
      _checkFirstTime();
    });
  }

  _checkFirstTime() async {
    if (getURL() != null) {
      setState(() {
        _urlCtrler.text = odooURL = getURL();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15.0),
            child: TextField(
              textAlign: TextAlign.left,
              controller: _urlCtrler,
              decoration: InputDecoration(
                labelText: "Odoo Server URL",
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: MaterialButton(
              child: Text(
                "Save Settings",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.indigo.shade400,
              onPressed: () {
                _saveURL(_urlCtrler.text);
              },
            ),
          )
        ],
      ),
    );
  }

  _saveURL(String url) async {
    if (!url.toLowerCase().contains("http://") &&
        !url.toLowerCase().contains("https://")) {
      url = "http://" + url;
    }
    if (url.length > 0 && url != " ") {
      isConnected().then((isInternet) {
        if (isInternet) {
          odoo = new Odoo(url: url);
          odoo.getDatabases().then((http.Response res) {
            saveOdooUrl(url);
            _showLogoutMessage(Strings.loginAgainMessage);
          }).catchError((error) {
            _showMessage(Strings.invalidUrlMessage);
          });
        }
      });
    } else {
      _showMessage("Please enter valid URL");
    }
  }

  _showMessage(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctxt) {
        return AlertDialog(
          title: Text(
            "Warning",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Ok",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _showLogoutMessage(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctxt) {
        return AlertDialog(
          title: Text(
            "Warning",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                _clearPrefs();
              },
              child: Text(
                "Logout",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _clearPrefs() async {
    odoo.destroy();
    preferences.remove(Constants.USER_PREF);
    preferences.remove(Constants.SESSION);
    pushAndRemoveUntil(Login());
  }
}
