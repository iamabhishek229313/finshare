import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:chart_components/chart_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finshare/models/user_data.dart';
import 'package:finshare/screens/home/add_credit_card.dart';
import 'package:finshare/screens/home/all_transactions.dart';
import 'package:finshare/screens/home/card_details.dart';
import 'package:finshare/screens/home/view_invites.dart';
import 'package:finshare/util/colors.dart';
import 'package:finshare/util/data_repo.dart';
import 'package:finshare/util/my_credit_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey();
  String? _email;
  UserData? _userData;

  List<Color> _colors = [
    Color.fromRGBO(225, 230, 233, 1),
    Color.fromRGBO(197, 204, 255, 1),
    Color.fromRGBO(1, 1, 1, 1),
    Color.fromRGBO(252, 217, 228, 1),
    Color.fromRGBO(233, 250, 245, 1),
    Color.fromRGBO(248, 242, 210, 1)
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<String?> _getEmail() async {
    User? _user = FirebaseAuth.instance.currentUser;
    _email = (await FirebaseFirestore.instance.collection('user_ids').doc(_user?.uid).get()).get("email");

    DocumentSnapshot _ds = await FirebaseFirestore.instance.collection('users_data').doc(_email).get();

    setState(() {
      _userData = UserData.fromJson(jsonDecode(jsonEncode(_ds.data())));
    });

    return _email;
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
              UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.blueGrey),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Text(
                      _userData?.name?.toUpperCase()[0] ?? "",
                      style: TextStyle(color: Colors.white, fontSize: 24.0),
                    ),
                  ),
                  accountName: Text(_userData?.name ?? ""),
                  accountEmail: Text(_email ?? "")),
              DrawerButton(
                icon: Icons.style_outlined,
                subTitle: "Delete or remove your card",
                title: "Manage your card",
                // bg: Colors.red.shade1,
                onPressed: () async {},
              ),
              DrawerButton(
                icon: Icons.receipt_long_rounded,
                subTitle: "View recent transactions",
                title: "All transactions",
                onPressed: () async {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (_) => AllTransactions()));
                },
              ),
              DrawerButton(
                icon: Icons.notifications_active_outlined,
                subTitle: "View notifications",
                title: "Notifications",
                onPressed: () async {},
              ),
              DrawerButton(
                icon: Icons.outbox_outlined,
                subTitle: "View invitations and shared access",
                title: "Invites",
                onPressed: () async {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ViewInvites()));
                },
              ),
              DrawerButton(
                icon: Icons.logout_outlined,
                subTitle: "Logout from this device",
                title: "Logout",
                bg: Colors.red.shade100,
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().then((value) => log("singed out : "));
                },
              ),
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
                    _userData?.name?.toUpperCase()[0] ?? "",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
        body: FutureBuilder(
          future: _getEmail(),
          builder: (BuildContext context, AsyncSnapshot email) {
            if (email.hasData == false)
              return Container(
                  constraints: BoxConstraints.expand(),
                  child: Center(
                      child: CircularProgressIndicator(
                    color: Colors.black,
                    backgroundColor: AppColors.background,
                  )));

            return StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users_data').doc(email.data).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData == false)
                    return Container(
                        constraints: BoxConstraints.expand(),
                        child: Center(
                            child: CircularProgressIndicator(
                          color: Colors.black,
                          backgroundColor: AppColors.background,
                        )));
                  UserData _userData = UserData.fromJson(jsonDecode(jsonEncode(snapshot.data?.data())));

                  return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: (_userData.cards?.length ?? 0) + 1,
                      itemBuilder: (context, index) {
                        return SizedBox(
                            height: screenHeight / 3.5,
                            child: (index < (_userData.cards?.length ?? 0))
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (_) => CardDetails(
                                                color: _colors[index % _colors.length],
                                                card_number: _userData.cards![index],
                                              )));
                                    },
                                    child: MyCreditCard(
                                      color: _colors[index % _colors.length],
                                      card_number: _userData.cards![index],
                                    ))
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
                      });
                });
          },
        ));
  }
}

class DrawerButton extends StatelessWidget {
  const DrawerButton({
    Key? key,
    this.bg = Colors.black12,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final Color bg;
  final String title;
  final String subTitle;
  final IconData icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9.0),
        color: this.bg,
      ),
      child: ListTile(
        dense: true,
        leading: Icon(this.icon),
        title: Text(this.title),
        subtitle: Text(this.subTitle),
        onTap: () async {
          onPressed();
        },
      ),
    );
  }
}
