import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:auto_animated/auto_animated.dart';
// import 'package:chart_components/chart_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finshare/models/user_data.dart';
import 'package:finshare/screens/home/add_credit_card.dart';
import 'package:finshare/screens/home/all_transactions.dart';
import 'package:finshare/screens/home/card_details.dart';
import 'package:finshare/screens/home/manage_cards.dart';
import 'package:finshare/screens/home/view_invites.dart';
import 'package:finshare/util/animation_stuffs.dart';
import 'package:finshare/util/colors.dart';
import 'package:finshare/util/constants.dart';
import 'package:finshare/util/data_repo.dart';
import 'package:finshare/util/my_credit_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey();
  String? _email;
  UserData? _userData;

  // List<Color> _colors = [
  //   Color.fromRGBO(22, 48, 85, 1),
  //   Color.fromRGBO(1, 1, 1, 1),
  //   Color.fromRGBO(225, 79, 92, 1),
  //   Color.fromRGBO(51, 151, 224, 1),
  //   Color.fromRGBO(18, 126, 121, 1),
  //   Color.fromRGBO(96, 43, 219, 1),
  // ];

  // List<Gradient> _gradient = [
  //   FlutterGradients.warmFlame(),
  //   FlutterGradients.greatWhale(),
  //   FlutterGradients.loveKiss(),
  //   FlutterGradients.nightFade(),
  //   FlutterGradients.sunnyMorning()
  // ];

  List<List<Color>> _gradients = [
    [Color.fromRGBO(134, 143, 150, 1), Color.fromRGBO(89, 97, 100, 1)],
    [Color.fromRGBO(9, 32, 63, 1), Color.fromRGBO(83, 120, 149, 1)],
    [Color.fromRGBO(199, 29, 111, 1), Color.fromRGBO(208, 150, 147, 1)],
    [Color.fromRGBO(247, 112, 98, 1), Color.fromRGBO(254, 81, 150, 1)],
    [Color.fromRGBO(43, 88, 118, 1), Color.fromRGBO(78, 67, 118, 1)],
    [Color.fromRGBO(135, 77, 162, 1), Color.fromRGBO(196, 58, 48, 1)]
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<String?> _getEmail() async {
    User? _user = FirebaseAuth.instance.currentUser;
    _email = (await FirebaseFirestore.instance.collection('user_ids').doc(_user?.uid).get()).get("email");

    DocumentSnapshot _ds = await FirebaseFirestore.instance.collection('users_data').doc(_email).get();

    if (mounted)
      setState(() {
        _userData = UserData.fromJson(jsonDecode(jsonEncode(_ds.data())));
      });

    return _email;
  }

  @override
  void dispose() {
    if (mounted) super.dispose();
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
                title: "Manage your cards",
                // bg: Colors.red.shade1,
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ManageCards(
                                email: _email,
                              )));
                },
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
                  SharedPreferences _prefs = await SharedPreferences.getInstance();
                  _prefs.setBool(AppConstants.firstUser, true).then((value) async {
                    await FirebaseAuth.instance.signOut().then((value) => Phoenix.rebirth(context));
                  });
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

                  return LiveList(
                    showItemInterval: Duration(milliseconds: 75),
                    showItemDuration: Duration(milliseconds: 175),
                    reAnimateOnVisibility: false,
                    scrollDirection: Axis.vertical,
                    itemCount: (_userData.cards?.length ?? 0) + 1,
                    itemBuilder: animationItemBuilder(
                      (index) {
                        return SizedBox(
                            height: screenHeight / 3.5,
                            child: (index < (_userData.cards?.length ?? 0))
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (_) => CardDetails(
                                                gradient: _gradients[index % _gradients.length],
                                                // color: _colors[index % _colors.length],
                                                card_number: _userData.cards![index],
                                              )));
                                    },
                                    child: Hero(
                                      transitionOnUserGestures: true,
                                      tag: _userData.cards![index],
                                      child: Material(
                                        type: MaterialType.transparency, // likely needed
                                        child: MyCreditCard(
                                          startColor: _gradients[index % _gradients.length][0],
                                          endColor: _gradients[index % _gradients.length][1],
                                          shadow: _gradients[index % _gradients.length][0],
                                          card_number: _userData.cards![index],
                                        ),
                                      ),
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
                      },
                    ),
                  );
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
