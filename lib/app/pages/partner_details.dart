import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:odoo_client/app/data/pojo/partners.dart';
import 'package:odoo_client/app/data/services/globals.dart';
import 'package:odoo_client/app/data/services/odoo_api.dart';
import 'package:odoo_client/app/data/services/odoo_response.dart';
import 'package:odoo_client/app/data/services/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PartnerDetails extends StatefulWidget {
  PartnerDetails({this.data});

  final data;

  @override
  _PartnerDetailsState createState() => _PartnerDetailsState();
}

class _PartnerDetailsState extends State<PartnerDetails> {
  var refreshkey = GlobalKey<RefreshIndicatorState>();
  var odoo;
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
  var country = "";
  Partner _partner;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _partner = widget.data;

    Utils().isConnected().then((isInternet) {
      if (!isInternet) {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: Text("No Internet Connection!")));
      }
    });

    print("----------------name------------------${_partner.name}");
    _getProfileData();
  }

  _getProfileData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString(Globals().loginPrefName) != null) {
      var user = jsonDecode(preferences.getString(Globals().loginPrefName));
      odoo = new Odoo(url: user['url'])
        ..searchRead("res.partner", [
          ["id", "=", _partner.id]
        ], []).then(
          (OdooResponse res) {
            if (!res.hasError()) {
              setState(() {
                String session = preferences.getString("session");
                session = session.split(",")[0].split(";")[0];
                final result = res.getResult()['records'][0];
                name = result["name"];
                email = result["email"];
                phone = result['phone'] is! bool ? result['phone'] : "N/A";
                print("----------phone-------------$phone");
                mobile = result['mobile'] is! bool ? result['mobile'] : "N/A";
                print("----------mobile-------------$mobile");
                street = result['street'] is! bool ? result['street'] : "";
                street2 = result['street2'] is! bool ? result['street2'] : "";
                city = result['city'] is! bool ? result['city'] : "";
                state_id =
                    result['state_id'] is! bool ? result['state_id'][1] : "";
                zip = result['zip'] is! bool ? result['zip'] : "";
                title = result['title'] is! bool ? result['title'][1] : "N/A";
                website =
                    result['website'] is! bool ? result['website'] : "N/A";
                jobposition =
                    result['function'] is! bool ? result['function'] : "N/A";
                country = result["country_id"] is! bool
                    ? result["country_id"][1]
                    : "N/A";

                image_URL = user['url'] +
                    "/web/content?model=res.partner&field=image&" +
                    session +
                    "&id=" +
                    _partner.id.toString();
              });
            }
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final upper_header = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 50),
          ),
          new Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1.0),
              borderRadius: BorderRadius.circular(70.0),
            ),
            padding: EdgeInsets.all(8.0),
            child: Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  image_URL != null
                      ? image_URL
                      : "https://image.flaticon.com/icons/png/512/1144/1144760.png",
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 5.0, bottom: 5.0)),
          Text(
            name,
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 2.0, bottom: 2.0)),
          Text(
            email,
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 8.0, bottom: 35.0)),
        ],
      ),
    );

    final lower = Container(
      child: ListView(
        children: <Widget>[
          Container(
            height: 75,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.grey.shade100,
              child: Row(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(right: 10.0)),
                  Image(
                    image: AssetImage("assets/worker.png"),
                    height: 30.0,
                    width: 30.0,
                  ),
                  Padding(padding: EdgeInsets.only(left: 10.0)),
                  Text(
                    jobposition != null ? jobposition : "",
                    style: TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat",
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              height: 75,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.grey.shade100,
                child: Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(right: 10.0)),
                    Image(
                      image: AssetImage("assets/mister.png"),
                      height: 30.0,
                      width: 30.0,
                    ),
                    Padding(padding: EdgeInsets.only(left: 10.0)),
                    Text(
                      title != null ? title : "",
                      style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            child: Container(
              height: 75,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.grey.shade100,
                child: Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(right: 10.0)),
                    Image(
                      image: AssetImage("assets/web.png"),
                      height: 30.0,
                      width: 30.0,
                    ),
                    Padding(padding: EdgeInsets.only(left: 10.0)),
                    Text(
                      website != null ? website : "",
                      style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            child: Container(
              height: 75,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.grey.shade100,
                child: Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(right: 10.0)),
                    Image(
                      image: AssetImage("assets/mobile.png"),
                      height: 30.0,
                      width: 30.0,
                    ),
                    Padding(padding: EdgeInsets.only(left: 10.0)),
                    Text(
                      mobile != null ? mobile : "",
                      style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            child: Container(
              height: 75,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.grey.shade100,
                child: Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(right: 10.0)),
                    Image(
                      image: AssetImage("assets/call.png"),
                      height: 30.0,
                      width: 30.0,
                    ),
                    Padding(padding: EdgeInsets.only(left: 10.0)),
                    Text(
                      phone != null ? phone : "",
                      style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            child: Container(
              height: 163,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.grey.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(right: 10.0)),
                    Image(
                      image: AssetImage("assets/user_location.png"),
                      height: 30.0,
                      width: 30.0,
                    ),
                    Padding(padding: EdgeInsets.only(left: 10.0)),
                    Container(
                      padding:
                          EdgeInsets.only(left: 10.0, bottom: 9.0, top: 9.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            street,
                            style: TextStyle(
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserrat",
                            ),
                          ),
                          Text(
                            city,
                            style: TextStyle(
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserrat",
                            ),
                          ),
                          Text(
                            state_id,
                            style: TextStyle(
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserrat",
                            ),
                          ),
                          Text(
                            zip,
                            style: TextStyle(
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserrat",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 260.0,
              floating: false,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                background: upper_header,
              ),
            ),
          ];
        },
        body: lower,
      ),
    );
  }
}
