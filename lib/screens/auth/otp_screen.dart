import 'dart:developer';

import 'package:finshare/util/progress_indc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OTP extends StatefulWidget {
  final String verificationId;
  final FirebaseAuth auth;
  OTP({Key? key, required this.verificationId, required this.auth}) : super(key: key);

  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  TextEditingController _codeController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          "Verify your device",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0),
                decoration: InputDecoration(helperText: "Enter OTP"),
              ),
              SizedBox(
                height: 16,
              ),
              FloatingActionButton(
                elevation: 0.0,
                onPressed: () async {
                  // MyProgress _myProgress = MyProgress(context);
                  // _myProgress.show();
                  final code = _codeController.text.trim();
                  AuthCredential credential =
                      PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: code);

                  UserCredential result = await widget.auth.signInWithCredential(credential);

                  User? user = result.user;

                  if (user != null) {
                    // _myProgress.hide();
                    log("Success with : " + user.phoneNumber.toString());
                    Navigator.pop(context);
                  } else {
                    print("Error");
                  }
                  // _myProgress.hide();
                },
                child: Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
