import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finshare/models/card_data.dart';
import 'package:finshare/models/invitation_modal.dart';
import 'package:finshare/models/user_data.dart';
import 'package:finshare/util/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GrantPermissions extends StatefulWidget {
  const GrantPermissions({Key? key, required this.chosedPerson, required this.cardData}) : super(key: key);
  final int chosedPerson;
  final CardData? cardData;

  @override
  _GrantPermissionsState createState() => _GrantPermissionsState();
}

class _GrantPermissionsState extends State<GrantPermissions> {
  List<String> categories = [
    "Income",
    "Housing",
    "Utilities",
    "Food",
    "Kids",
    "Clothing",
    "Donation",
    "Insurance",
    "Health care",
    "Debt",
    "Subscription",
    "Gift",
    "Medical"
  ];

  Set<String> _chosedCategories = {};

  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;
  final TextEditingController _perTranscLimitController = TextEditingController();
  final TextEditingController _dailyLimitController = TextEditingController();
  final TextEditingController _monthlyLimitController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: AppColors.background,
          title: Text(
            "Permissions",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () async {
            widget.cardData?.members?.last!.permissions = Permissions(
                perTransactionLimit: double.parse(_perTranscLimitController.text),
                dailyLimit: double.parse(_dailyLimitController.text),
                monthlyLimit: double.parse(_monthlyLimitController.text),
                timingFrom: (_fromTime?.format(context).toString()),
                timingTo: (_toTime?.format(context).toString()),
                categories: _chosedCategories.toList());

            // log("Atlast all details are : " + widget.cardData!.toJson().toString());
            User? _user = FirebaseAuth.instance.currentUser;
            String _email =
                (await FirebaseFirestore.instance.collection('user_ids').doc(_user?.uid).get()).get("email");

            Invitation _invitation = new Invitation(
                createdAt: DateTime.now().microsecondsSinceEpoch,
                from: _email,
                status: "Pending",
                cardNumber: widget.cardData?.cARDNUMBER,
                to: widget.cardData?.members?.last!.emailId,
                members: widget.cardData?.members?.last);

            DocumentSnapshot _ds = await FirebaseFirestore.instance
                .collection('users_data')
                .doc(widget.cardData?.members?.last!.emailId)
                .get();

            if (_ds.exists) {
              String? documentHash;
              await FirebaseFirestore.instance.collection('invitations').add(_invitation.toJson()).then((value) {
                documentHash = value.id;
              });

              await FirebaseFirestore.instance.collection('invitations').doc(documentHash).set(_invitation.toJson());

              DocumentSnapshot _fromDs = await FirebaseFirestore.instance.collection('users_data').doc(_email).get();
              UserData _fromUser = UserData.fromJson(jsonDecode(jsonEncode(_fromDs.data())));
              _fromUser.invitesSent?.add(documentHash ?? "");
              await FirebaseFirestore.instance.collection('users_data').doc(_email).update(_fromUser.toJson());

              DocumentSnapshot _toDs = await FirebaseFirestore.instance
                  .collection('users_data')
                  .doc(widget.cardData?.members?.last!.emailId)
                  .get();
              UserData _toUser = UserData.fromJson(jsonDecode(jsonEncode(_toDs.data())));
              _toUser.invites?.add(documentHash ?? "");
              await FirebaseFirestore.instance
                  .collection('users_data')
                  .doc(widget.cardData?.members?.last!.emailId)
                  .update(_toUser.toJson());

              log("Invite sent!");
              Navigator.pop(context);
              Navigator.pop(context);
            } else {
              log("To user doesn't exists");
              Navigator.pop(context);
              Navigator.pop(context);
            }

            // await FirebaseFirestore.instance
            //     .collection("cards")
            //     .doc(widget.cardData?.cARDNUMBER)
            //     .update(widget.cardData!.toJson());
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.075,
            color: AppColors.cardColor,
            child: Center(
              child: Text(
                "INVITE",
                style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 18.0),
              ),
            ),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 32.0),
          children: [
            Text(
              (widget.chosedPerson == 0 ? "Partner" : (widget.chosedPerson == 1 ? "Child" : "Other")) + " as member",
              style: TextStyle(fontSize: 28.0, color: Colors.black, fontWeight: FontWeight.w700),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "To help members learn to use credit responsibly, Owner can set spending limits.",
                  style: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _perTranscLimitController,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                          prefix: Text("\$ "),
                          labelText: "Per transaction limit",
                          labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _dailyLimitController,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                          prefix: Text("\$ "),
                          labelText: "Daily limit",
                          labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _monthlyLimitController,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                          prefix: Text("\$ "),
                          labelText: "Monthly limit",
                          labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 22.0,
            ),
            (widget.chosedPerson == 1 || widget.chosedPerson == 2)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Choose timings of which they do transaction",
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "From",
                              style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            flex: 8,
                            child: OutlineButton(
                              onPressed: () async {
                                TimeOfDay? selectedTime = await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                );
                                if (selectedTime != null)
                                  setState(() {
                                    _fromTime = selectedTime;
                                  });
                              },
                              child: _fromTime == null
                                  ? Text("Not selected")
                                  : Text(
                                      _fromTime!.format(context).toString(),
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "To",
                              style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            flex: 8,
                            child: OutlineButton(
                              onPressed: () async {
                                TimeOfDay? selectedTime = await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                );
                                if (selectedTime != null)
                                  setState(() {
                                    _toTime = selectedTime;
                                  });
                              },
                              child: _toTime == null
                                  ? Text("Not selected")
                                  : Text(
                                      _toTime!.format(context).toString(),
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                : SizedBox.shrink(),
            SizedBox(
              height: 16.0,
            ),
            (widget.chosedPerson == 1)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Choose categories",
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 8.0,
                        children: List.generate(
                            categories.length,
                            (index) => (_chosedCategories.contains(categories[index])
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _chosedCategories.remove(categories[index]);
                                      });
                                    },
                                    child: Chip(
                                        avatar: Icon(
                                          Icons.check,
                                          size: 18.0,
                                          color: Colors.white,
                                        ),
                                        backgroundColor: AppColors.cardColor,
                                        label: Text(
                                          categories[index],
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _chosedCategories.add(categories[index]);
                                      });
                                    },
                                    child: Chip(label: Text(categories[index]))))),
                      )
                    ],
                  )
                : SizedBox.shrink()
          ],
        ));
  }
}
