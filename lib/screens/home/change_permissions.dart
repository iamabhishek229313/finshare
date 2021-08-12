import 'dart:convert';
import 'dart:developer';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finshare/models/card_data.dart';
import 'package:finshare/util/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChangePermissions extends StatefulWidget {
  const ChangePermissions({Key? key, required this.cardNumber, required this.mem, required this.index})
      : super(key: key);
  final String cardNumber;
  final Members? mem;
  final int index;
  @override
  _ChangePermissionsState createState() => _ChangePermissionsState();
}

class _ChangePermissionsState extends State<ChangePermissions> {
  int? chosedPerson;

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
    _perTranscLimitController.text = widget.mem!.permissions?.perTransactionLimit.toString() ?? "";
    _dailyLimitController.text = widget.mem!.permissions?.dailyLimit.toString() ?? "";
    _monthlyLimitController.text = widget.mem!.permissions?.monthlyLimit.toString() ?? "";

    if (widget.mem!.category == "Partner") {
      chosedPerson = 0;
    } else if (widget.mem!.category == "Child") {
      chosedPerson = 1;

      bool amFrom = (widget.mem!.permissions!.timingFrom![widget.mem!.permissions!.timingFrom!.length - 2] == 'A');
      bool amTo = (widget.mem!.permissions!.timingFrom![widget.mem!.permissions!.timingTo!.length - 2] == 'A');

      _fromTime = TimeOfDay(
          hour: int.parse(widget.mem!.permissions!.timingFrom!.split(':')[0]) + (amFrom ? 0 : 12),
          minute: int.parse(widget.mem!.permissions!.timingFrom!.split(':')[0]));
      _toTime = TimeOfDay(
          hour: int.parse(widget.mem!.permissions!.timingTo!.split(':')[0]) + (amTo ? 0 : 12),
          minute: int.parse(widget.mem!.permissions!.timingTo!.split(':')[0]));

      for (int i = 0; i < (widget.mem!.permissions!.categories!.length); i++) {
        _chosedCategories.add(widget.mem!.permissions!.categories![i]);
      }
    } else {
      chosedPerson = 2;
      bool amFrom = (widget.mem!.permissions!.timingFrom![widget.mem!.permissions!.timingFrom!.length - 2] == 'A');
      bool amTo = (widget.mem!.permissions!.timingFrom![widget.mem!.permissions!.timingTo!.length - 2] == 'A');

      _fromTime = TimeOfDay(
          hour: int.parse(widget.mem!.permissions!.timingFrom!.split(':')[0]) + (amFrom ? 0 : 12),
          minute: int.parse(widget.mem!.permissions!.timingFrom!.split(':')[0]));
      _toTime = TimeOfDay(
          hour: int.parse(widget.mem!.permissions!.timingTo!.split(':')[0]) + (amTo ? 0 : 12),
          minute: int.parse(widget.mem!.permissions!.timingTo!.split(':')[0]));
    }
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
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height * 0.075,
          child: ArgonButton(
              color: Colors.red.shade100,
              roundLoadingShape: false,
              height: double.maxFinite,
              width: double.maxFinite,
              child: Center(
                child: Text(
                  "CHANGE PERMISSIONS",
                  style: TextStyle(fontWeight: FontWeight.w900, color: Colors.red.shade700, fontSize: 18.0),
                ),
              ),
              loader: Container(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
              onTap: (startLoading, stopLoading, btnState) async {
                if (btnState == ButtonState.Idle) {
                  startLoading();
                  DocumentSnapshot _ds =
                      await FirebaseFirestore.instance.collection('cards').doc(widget.cardNumber).get();
                  CardData _cardData = CardData.fromJson(jsonDecode(jsonEncode(_ds.data())));

                  _cardData.members![widget.index]!.permissions = Permissions(
                      perTransactionLimit: double.parse(_perTranscLimitController.text),
                      dailyLimit: double.parse(_dailyLimitController.text),
                      monthlyLimit: double.parse(_monthlyLimitController.text),
                      timingFrom: (_fromTime?.format(context).toString()),
                      timingTo: (_toTime?.format(context).toString()),
                      categories: _chosedCategories.toList());

                  await FirebaseFirestore.instance
                      .collection('cards')
                      .doc(widget.cardNumber)
                      .update(_cardData.toJson());

                  log("Permissions chnaged!");
                  stopLoading();
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              }),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 32.0),
          children: [
            Text(
              (chosedPerson == 0 ? "Partner" : (chosedPerson == 1 ? "Child" : "Other")) + " as member",
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
            (chosedPerson == 1 || chosedPerson == 2)
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
            (chosedPerson == 1)
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
