import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:odoo_client/app/data/services/odoo_api.dart';
import 'package:odoo_client/app/data/services/odoo_response.dart';
import 'package:odoo_client/app/data/services/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:odoo_client/app/data/services/globals.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Odoo _odoo;
  String name = "";
  String image_URL = "";
  String email = "";
  var phone = "";
  var mobile = "";
  var street = "";
  var street2 = "";
  var city = "";
  var state_id = "";
  var zip = "";
  var title = "";
  var website = "";
  var jobposition = "";

  _getUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString(Globals().loginPrefName) != null) {
      var user = jsonDecode(preferences.getString(Globals().loginPrefName));
      _odoo = new Odoo(url: user['url'])
        ..searchRead("res.users", [
          ["id", "=", user['uid']]
        ], []).then(
          (OdooResponse res) {
            if (!res.hasError()) {
              setState(() {
                String session = preferences.getString("session");
                session = session.split(",")[0].split(";")[0];
                final result = res.getResult()['records'][0];
                name = result['name'] is! bool ? result['name'] : "";
                image_URL = user['url'] +
                    "/web/content?model=res.users&field=image&" +
                    session +
                    "&id=" +
                    user['uid'].toString();
                email = result['email'] is! bool ? result['email'] : "";
              });
            } else {
              Utils(context: context)
                  .showMessage("Warning", res.getErrorMessage());
            }
          },
        );
    }
  }

  _clearPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var user = jsonDecode(preferences.getString(Globals().loginPrefName));
    _odoo = Odoo(url: user['url']);
    _odoo.destroy();
    preferences.remove(Globals().loginPrefName);
    preferences.remove("session");
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (_) => false,
    );
  }

  _getProfileData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString(Globals().loginPrefName) != null) {
      var user = jsonDecode(preferences.getString(Globals().loginPrefName));
      _odoo = new Odoo(url: user['url'])
        ..searchRead("res.partner", [
          ["id", "=", user['partner_id']] //model
        ], []).then(
          (OdooResponse res) {
            if (!res.hasError()) {
              setState(() {
                final result = res.getResult()['records'][0];
                phone = result['phone'] is! bool ? result['phone'] : "N/A";
                mobile = result['mobile'] is! bool ? result['mobile'] : "N/A";
                street = result['street'] is! bool ? result['street'] : "";
                street2 = result['street2'] is! bool ? result['street2'] : "";
                city = result['city'] is! bool ? result['city'] : "";
                state_id =
                    result['state_id'][1] is! bool ? result['state_id'][1] : "";
                zip = result['zip'] is! bool ? result['zip'] : "";
                title = result['title'][1] is! bool ? result['title'][1] : "N/A";
                website = result['website'] is! bool ? result['website'] : "N/A";
                jobposition =
                    result['function'] is! bool ? result['function'] : "N/A";
              });
            }
          },
        );
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
    _getProfileData();
    Utils().isConnected().then((isInternet) {
      if (!isInternet) {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: Text("No Internet Connection!")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final upper_header = Container(
      color: Colors.indigo,
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Container(
                width: 150.0,
                height: 150.0,
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.all(25.0),
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 25.0,
                      color: Colors.orange,
                    )
                  ],
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(
                      image_URL != null
                          ? image_URL
                          : "https://i1.wp.com/www.molddrsusa.com/wp-content/uploads/2015/11/profile-empty.png.250x250_q85_crop.jpg?ssl=1",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Montserrat",
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  email,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: "Montserrat",
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final lower = Container(
      child: ListView(
        children: <Widget>[
          Container(
            height: 75,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(right: 10.0)),
                Icon(Icons.person_pin),
                Padding(padding: EdgeInsets.only(left: 10.0)),
                Text(
                  jobposition,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Montserrat",
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            height: 75,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(right: 10.0)),
                Icon(Icons.title, color: Colors.black),
                Padding(padding: EdgeInsets.only(left: 10.0)),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Montserrat",
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            height: 75,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(right: 10.0)),
                Icon(Icons.web_asset, color: Colors.black),
                Padding(padding: EdgeInsets.only(left: 10.0)),
                Text(
                  website,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Montserrat",
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            height: 75,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(right: 10.0)),
                Icon(Icons.phone_android, color: Colors.black),
                Padding(padding: EdgeInsets.only(left: 10.0)),
                Text(
                  mobile,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Montserrat",
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            height: 75,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(right: 10.0)),
                Icon(Icons.phone, color: Colors.black),
                Padding(padding: EdgeInsets.only(left: 10.0)),
                Text(
                  phone,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Montserrat",
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(right: 10.0)),
                Icon(Icons.location_city),
                Padding(padding: EdgeInsets.only(left: 10.0)),
                Container(
                  padding: EdgeInsets.only(left: 10.0, bottom: 9.0, top: 9.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        street,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "Montserrat",
                        ),
                      ),
                      Text(
                        city,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "Montserrat",
                        ),
                      ),
                      Text(
                        state_id,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "Montserrat",
                        ),
                      ),
                      Text(
                        zip,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "Montserrat",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider()
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext ctxt) {
                    return AlertDialog(
                      title: Text(
                        "Logged Out",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      content: Text(
                        "Are you sure you want to logged out?",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
              })
        ],
      ),
      body: Column(
        children: <Widget>[upper_header, Expanded(child: lower)],
      ),
    );
  }
}
