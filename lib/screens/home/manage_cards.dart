import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finshare/models/user_data.dart';
import 'package:finshare/screens/home/home_screen.dart';
import 'package:finshare/util/colors.dart';
import 'package:finshare/util/my_credit_card.dart';
import 'package:flutter/material.dart';

class ManageCards extends StatefulWidget {
  const ManageCards({Key? key, required this.email}) : super(key: key);
  final String? email;
  @override
  _ManageCardsState createState() => _ManageCardsState();
}

class _ManageCardsState extends State<ManageCards> {
  List<Color> _colors = [
    Color.fromRGBO(1, 1, 1, 1),
    Color.fromRGBO(225, 79, 92, 1),
    Color.fromRGBO(51, 151, 224, 1),
    Color.fromRGBO(96, 43, 219, 1),
  ];
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0.0,
          title: Text(
            "Manage your cards",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          actions: [],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users_data').doc(widget.email).snapshots(),
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

              return SizedBox(
                height: screenHeight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Tap on the cards to view options",
                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                    Expanded(
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: (_userData.cards?.length ?? 0) + 1,
                          itemBuilder: (context, index) {
                            return SizedBox(
                                height: screenHeight / 3.5,
                                child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
                                        elevation: 10.0,
                                        builder: (BuildContext context) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.background, borderRadius: BorderRadius.circular(20.0)),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 16.0),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: 60.0,
                                                      height: 8.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10.0),
                                                        color: Colors.blueGrey.shade100,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 16.0,
                                                    ),
                                                    DrawerButton(
                                                        title: "Delete this Card",
                                                        subTitle: "Remove this card.",
                                                        icon: Icons.delete_forever_outlined,
                                                        bg: Colors.red.shade100,
                                                        onPressed: () async {
                                                          DocumentSnapshot _ds = await FirebaseFirestore.instance
                                                              .collection('users_data')
                                                              .doc(widget.email)
                                                              .get();

                                                          UserData _user =
                                                              UserData.fromJson(jsonDecode(jsonEncode(_ds.data())));

                                                          _user.cards!.remove(_userData.cards![index]);

                                                          await FirebaseFirestore.instance
                                                              .collection('users_data')
                                                              .doc(widget.email)
                                                              .update(_user.toJson());

                                                          Navigator.of(context).pop();
                                                        }),
                                                    SizedBox(
                                                      height: 32.0,
                                                    )
                                                  ],
                                                )),
                                          );
                                        },
                                      );
                                    },
                                    child: MyCreditCard(
                                      color: _colors[index % _colors.length].withAlpha(400),
                                      card_number: _userData.cards![index],
                                    )));
                          }),
                    ),
                  ],
                ),
              );
            }));
  }
}
