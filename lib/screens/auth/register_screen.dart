import 'dart:convert';
import 'dart:developer';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finshare/models/email.dart';
import 'package:finshare/models/user_data.dart';
import 'package:finshare/screens/auth/login_screen.dart';
import 'package:finshare/screens/auth/otp_screen.dart';
import 'package:finshare/util/colors.dart';
import 'package:finshare/util/progress_indc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  Future _registerUser() async {
    User? _user = FirebaseAuth.instance.currentUser;

    /// [At 'users_id' collections we have made user_id -> {email_id}]
    await FirebaseFirestore.instance
        .collection('user_ids')
        .doc(_user?.uid.toString())
        .set(new Email(email: _emailController.text).toJson());

    UserData _userData = UserData(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: int.parse(_phoneController.text.trim()),
        userId: _user?.uid,
        createdAt: DateTime.now().microsecondsSinceEpoch,
        cards: [],
        invites: [],
        invitesSent: []);

    await FirebaseFirestore.instance.collection('users_data').doc(_emailController.text).set(_userData.toJson());
    log("User Registered");
    return "";
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: AppColors.background,
          title: Text(
            "Let's get connected",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 32.0),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Registration",
                  style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.w900),
                ),
                SizedBox(
                  height: 32.0,
                ),
                TextField(
                  controller: _nameController,
                  cursorColor: Colors.black,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: "Name",
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextField(
                  controller: _emailController,
                  cursorColor: Colors.black,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: "Email address",
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.black,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                  ),
                ),
                SizedBox(
                  height: 32.0,
                ),
                Align(
                  child: SizedBox(
                    child: ArgonButton(
                      width: 4000,
                      height: 50,
                      borderRadius: 5.0,
                      color: AppColors.cardColor,
                      child: Text(
                        "Register",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
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
                          User? _user = FirebaseAuth.instance.currentUser;

                          /// [At 'users_id' collections we have made user_id -> {email_id}]
                          await FirebaseFirestore.instance
                              .collection('user_ids')
                              .doc(_user?.uid.toString())
                              .set(new Email(email: _emailController.text).toJson());

                          UserData _userData = UserData(
                              name: _nameController.text.trim(),
                              email: _emailController.text.trim(),
                              phone: int.parse(_phoneController.text.trim()),
                              userId: _user?.uid,
                              createdAt: DateTime.now().microsecondsSinceEpoch,
                              cards: [],
                              invites: [],
                              invitesSent: []);

                          await FirebaseFirestore.instance
                              .collection('users_data')
                              .doc(_emailController.text)
                              .set(_userData.toJson());
                          log("User Registered");
                          stopLoading();
                          Phoenix.rebirth(context);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
