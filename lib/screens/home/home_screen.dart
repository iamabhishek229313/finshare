import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(accountName: Text("admin"), accountEmail: Text("admin@gmail.com")),
            ListTile(
              dense: true,
              tileColor: Colors.blueGrey[100],
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              subtitle: Text("Logout from this device"),
              onTap: () async {
                await FirebaseAuth.instance.signOut().then((value) => log("singed out : "));
              },
            )
          ],
        ),
      ),
      appBar: AppBar(),
      body: Container(
          color: Colors.blue,
          child: Center(
            child: Text("Home"),
          )),
    );
  }
}
