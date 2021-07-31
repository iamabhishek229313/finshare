import 'dart:developer';
import 'dart:math' as math;

import 'package:chart_components/chart_components.dart';
import 'package:finshare/screens/home/add_credit_card.dart';
import 'package:finshare/screens/home/card_details.dart';
import 'package:finshare/util/colors.dart';
import 'package:finshare/util/data_repo.dart';
import 'package:finshare/util/my_credit_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        key: _scaffoldkey,
        backgroundColor: AppColors.background,
        endDrawer: Drawer(
          elevation: 10.0,
          child: ListView(
            children: [
              UserAccountsDrawerHeader(accountName: Text("admin"), accountEmail: Text("admin@gmail.com")),
              DrawerButton(),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0.0,
          title: Text(
            "Your Cards",
            style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 22),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () {
                  _scaffoldkey.currentState?.openEndDrawer();
                },
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Text(
                    'A',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
        body: ListView.builder(
            itemCount: 10,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return SizedBox(
                  height: screenHeight / 3.5,
                  child: (index < 9)
                      ? GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => CardDetails()));
                          },
                          child: MyCreditCard())
                      : GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddCreditCard()));
                          },
                          child: Container(
                              margin: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                  color: Colors.blue.withAlpha(300), borderRadius: BorderRadius.circular(7)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 54.0,
                                    color: Colors.black87,
                                  ),
                                  Text("Add more",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w900,
                                      ))
                                ],
                              )),
                        ));
            }));
  }
}

class DrawerButton extends StatelessWidget {
  const DrawerButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9.0),
        color: Colors.blue.shade100,
      ),
      child: ListTile(
        dense: true,
        leading: Icon(Icons.logout),
        title: Text("Logout"),
        subtitle: Text("Logout from this device"),
        onTap: () async {
          await FirebaseAuth.instance.signOut().then((value) => log("singed out : "));
        },
      ),
    );
  }
}
