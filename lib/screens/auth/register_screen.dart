import 'dart:convert';
import 'dart:developer';

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
                    alignment: Alignment.center,
                    child: FloatingActionButton(
                      onPressed: () async {
                        _registerUser().then((value) => Phoenix.rebirth(context));
                      },
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ))
              ],
            ),
          ],
        )

        // SingleChildScrollView(
        //   child: Container(
        //     width: screenWidth,
        //     height: screenHeight,
        //     padding: EdgeInsets.symmetric(horizontal: 32),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: <Widget>[
        //         Text(
        //           "Register",
        //           style: TextStyle(
        //               fontSize: screenWidth / 7,
        //               fontWeight: FontWeight.w900,
        //               color: Colors.black),
        //         ),
        //         SizedBox(
        //           height: screenHeight / 20,
        //         ),
        //         Container(
        //           padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
        //           width: screenWidth,
        //           child: TextField(
        //             textInputAction: TextInputAction.unspecified,
        //             controller: _fullNameController,
        //             keyboardType: TextInputType.name,
        //             cursorColor: Colors.black,
        //             scrollPadding: EdgeInsets.zero,
        //             style:
        //                 TextStyle(fontSize: 18.0, fontWeight: FontWeight.w100),
        //             decoration: InputDecoration(
        //                 hintText: "Enter Full Name...", prefixText: ""),
        //           ),
        //         ),
        //         SizedBox(
        //           height: 20,
        //         ),
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: [
        //             Container(
        //               padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
        //               width: screenWidth / 8,
        //               child: TextField(
        //                 maxLength: 2,
        //                 controller: _codeController,
        //                 keyboardType: TextInputType.number,
        //                 cursorColor: Colors.black,
        //                 scrollPadding: EdgeInsets.zero,
        //                 style: TextStyle(
        //                     fontSize: 18.0, fontWeight: FontWeight.w100),
        //                 decoration:
        //                     InputDecoration(hintText: "1", prefixText: "+"),
        //               ),
        //             ),
        //             Container(
        //               width: 1,
        //               height: 32,
        //               color: Colors.black,
        //             ),
        //             Container(
        //               padding: EdgeInsets.symmetric(horizontal: 10),
        //               width: screenWidth - 80 - screenWidth / 10,
        //               child: TextField(
        //                 maxLength: 10,
        //                 controller: _phoneController,
        //                 keyboardType: TextInputType.number,
        //                 cursorColor: Colors.black,
        //                 scrollPadding: EdgeInsets.zero,
        //                 style: TextStyle(
        //                     fontSize: 18.0, fontWeight: FontWeight.w100),
        //                 decoration: InputDecoration(
        //                     hintText: 'Enter phone no', prefixText: ""),
        //               ),
        //             ),
        //           ],
        //         ),
        //         SizedBox(height: 10),
        //         Container(
        //           padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
        //           width: screenWidth,
        //           child: TextField(
        //             textInputAction: TextInputAction.unspecified,
        //             controller: _emailController,
        //             keyboardType: TextInputType.emailAddress,
        //             cursorColor: Colors.black,
        //             scrollPadding: EdgeInsets.zero,
        //             style:
        //                 TextStyle(fontSize: 18.0, fontWeight: FontWeight.w100),
        //             decoration: InputDecoration(
        //                 hintText: "Enter email id...", prefixText: ""),
        //           ),
        //         ),
        //         SizedBox(
        //           height: screenHeight / 20,
        //         ),
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Container(
        //               child: Row(
        //                 children: [
        //                   GestureDetector(
        //                       onTap: () {
        //                         Navigator.push(context,
        //                             MaterialPageRoute(builder: (_) => Login()));
        //                       },
        //                       child: Text(
        //                         "Existing user?, ",
        //                         style: TextStyle(
        //                             fontWeight: FontWeight.w100,
        //                             fontSize: 16.0,
        //                             color: Colors.black),
        //                       )),
        //                   GestureDetector(
        //                       onTap: () {
        //                         Navigator.push(context,
        //                             MaterialPageRoute(builder: (_) => Login()));
        //                       },
        //                       child: Text(
        //                         "Login",
        //                         style: TextStyle(
        //                             fontWeight: FontWeight.bold,
        //                             fontSize: 16.0,
        //                             color: Colors.blueAccent),
        //                       )),
        //                 ],
        //               ),
        //             ),
        //             IconButton(
        //               splashColor: Colors.white10,
        //               focusColor: Colors.white10,
        //               highlightColor: Colors.white10,
        //               icon: Icon(
        //                 Icons.arrow_forward,
        //                 color: Colors.blueAccent,
        //               ),
        //               onPressed: () {
        //                 final phone = _phoneController.text.trim();
        //                 loginUser(phone, context);
        //               },
        //             )
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // )

        );
  }
}
