import 'dart:developer';

import 'package:finshare/screens/auth/otp_screen.dart';
import 'package:finshare/screens/auth/registration_screen.dart';
import 'package:finshare/util/progress_indc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  Future<FirebaseAuth> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    // MyProgress _myProgress = MyProgress(context);

    // _myProgress.show();
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
                  "LOGIN",
                  style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.black,
                  scrollPadding: EdgeInsets.zero,
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(helperText: 'Phone number', prefixText: "+91"),
                ),
                SizedBox(
                  height: 16,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FloatingActionButton(
                    elevation: 0.0,
                    onPressed: () {
                      final phone = _phoneController.text.trim();
                      loginUser(phone, context);
                    },
                    child: Icon(Icons.arrow_forward),
                  ),
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => Registration()));
                    },
                    child: Text(
                      "New user? Register now",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black),
                    )),
              ],
            ),
          ),
        ));
  }
}
