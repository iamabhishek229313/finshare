import 'dart:developer';

import 'package:finshare/screens/auth/otp_screen.dart';
import 'package:finshare/screens/auth/register_screen.dart';
import 'package:finshare/util/progress_indc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  Future<FirebaseAuth> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    log("phone is : " + phone);
    _auth.verifyPhoneNumber(
        phoneNumber: "+91" + phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          UserCredential _userCredential = await _auth.signInWithCredential(credential);
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
                        phoneNumber: _phoneController.text,
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: screenWidth,
              height: screenHeight,
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 44.0, fontWeight: FontWeight.w900, color: Colors.black),
                  ),
                  SizedBox(
                    height: screenHeight / 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: _phoneController,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        labelStyle: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Align(
                    child: FloatingActionButton(
                      onPressed: () async {
                        final phone = _phoneController.text.trim();
                        loginUser(phone, context);
                      },
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.2,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
