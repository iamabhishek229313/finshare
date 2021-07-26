import 'dart:developer';

import 'package:finshare/screens/auth/login_screen.dart';
import 'package:finshare/screens/auth/otp_screen.dart';
import 'package:finshare/util/progress_indc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();

  Future<FirebaseAuth> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    log("phone is : " + phone);
    _auth.verifyPhoneNumber(
        phoneNumber: "+91" + phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          UserCredential _userCredential =
              await _auth.signInWithCredential(credential);
          User? _user = _userCredential.user;
          if (_user != null) {}
        },
        verificationFailed: (FirebaseAuthException exception) {
          log(exception.toString());
        },
        codeSent: (String verificationId, int? forceResendingToken) async {
          final value = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => OTP(
                        auth: _auth,
                        verificationId: verificationId,
                      )));
        },
        codeAutoRetrievalTimeout: (String re) {
          log("Time out !!!! code happend");
        });
    // _myProgress.hide();
    return _auth;
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            width: screenWidth,
            height: screenHeight,
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Register",
                  style: TextStyle(
                      fontSize: screenWidth / 7,
                      fontWeight: FontWeight.w900,
                      color: Colors.black),
                ),
                SizedBox(
                  height: screenHeight / 20,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                  width: screenWidth,
                  child: TextField(
                    textInputAction: TextInputAction.unspecified,
                    controller: _fullNameController,
                    keyboardType: TextInputType.name,
                    cursorColor: Colors.black,
                    scrollPadding: EdgeInsets.zero,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w100),
                    decoration: InputDecoration(
                        hintText: "Enter Full Name...", prefixText: ""),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                      width: screenWidth / 8,
                      child: TextField(
                        maxLength: 2,
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.black,
                        scrollPadding: EdgeInsets.zero,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w100),
                        decoration:
                            InputDecoration(hintText: "1", prefixText: "+"),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 32,
                      color: Colors.black,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: screenWidth - 80 - screenWidth / 10,
                      child: TextField(
                        maxLength: 10,
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.black,
                        scrollPadding: EdgeInsets.zero,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w100),
                        decoration: InputDecoration(
                            hintText: 'Enter phone no', prefixText: ""),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                  width: screenWidth,
                  child: TextField(
                    textInputAction: TextInputAction.unspecified,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.black,
                    scrollPadding: EdgeInsets.zero,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w100),
                    decoration: InputDecoration(
                        hintText: "Enter email id...", prefixText: ""),
                  ),
                ),
                SizedBox(
                  height: screenHeight / 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) => Login()));
                              },
                              child: Text(
                                "Existing user?, ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontSize: 16.0,
                                    color: Colors.black),
                              )),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) => Login()));
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.blueAccent),
                              )),
                        ],
                      ),
                    ),
                    IconButton(
                      splashColor: Colors.white10,
                      focusColor: Colors.white10,
                      highlightColor: Colors.white10,
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () {
                        final phone = _phoneController.text.trim();
                        loginUser(phone, context);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
