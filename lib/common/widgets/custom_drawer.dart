import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              radius: 30.0,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(
                "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/John_Doe%2C_born_John_Nommensen_Duchac.jpg/1200px-John_Doe%2C_born_John_Nommensen_Duchac.jpg",
              ),
            ),
            accountName: Text("Mustafa Lokhandwala"),
            accountEmail: Text("mustafa.mscit15@gmail.com"),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("Edit Profile"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
