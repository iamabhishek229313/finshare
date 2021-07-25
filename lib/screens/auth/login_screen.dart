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
        body: Container(
      width: screenWidth,
      height: screenHeight,
      color: Colors.red,
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "LOGIN",
            style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(
            height: 16,
          ),
          // SizedBox(
          //   height: 50.0,
          //   width: 400,
          //   child: Row(
          //     children: [
          //       TextField(
          //         controller: _phoneController,
          //         keyboardType: TextInputType.number,
          //         cursorColor: Theme.of(context).primaryColor,
          //         decoration: InputDecoration(helperText: 'Phone number'),
          //       ),
          //     ],
          //   ),
          // ),
          // Row(
          //   children: <Widget>[
          //     // Center(
          //     //   child: Text(
          //     //     "+91",
          //     //     style: TextStyle(fontSize: 22.0),
          //     //   ),
          //     // ),
          //     // SizedBox(
          //     // width: 8.0,
          //     // ),
          //     TextField(
          //       controller: _phoneController,
          //       keyboardType: TextInputType.number,
          //       cursorColor: Theme.of(context).primaryColor,
          //       decoration: InputDecoration(helperText: 'Phone number'),
          //     ),
          //   ],
          // ),
          SizedBox(
            height: 16,
          ),
          FloatingActionButton(
            elevation: 0.0,
            onPressed: () {
              final phone = _phoneController.text.trim();
              loginUser(phone, context);
            },
            child: Icon(Icons.arrow_forward),
          ),
          SizedBox(height: 20.0),
          GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => Registration()));
              },
              child: Text(
                "New user? Register now",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black),
              ))
        ],
      ),
    ));
  }
}
