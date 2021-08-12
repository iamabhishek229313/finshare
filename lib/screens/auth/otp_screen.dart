import 'dart:developer';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:finshare/util/colors.dart';
import 'package:finshare/util/progress_indc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTP extends StatefulWidget {
  final String verificationId;
  final FirebaseAuth auth;
  final String phoneNumber;
  OTP({required this.phoneNumber, Key? key, required this.verificationId, required this.auth}) : super(key: key);

  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  TextEditingController _codeController = new TextEditingController();
  String currentText = "";

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
                  "Verify",
                  style: TextStyle(fontSize: 44.0, fontWeight: FontWeight.w900, color: Colors.black),
                ),
                SizedBox(
                  height: screenHeight / 20,
                ),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  hintCharacter: ".",
                  animationType: AnimationType.none,
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      activeFillColor: Colors.white,
                      activeColor: Colors.black,
                      inactiveColor: Colors.black),
                  cursorColor: Colors.black,
                  animationDuration: Duration(milliseconds: 300),
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  onCompleted: (v) {
                    print("Completed");
                  },
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      currentText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    return false;
                  },
                ),
                SizedBox(height: 20.0),
                Align(
                  child: SizedBox(
                    child: ArgonButton(
                      width: 400,
                      height: 50,
                      borderRadius: 5.0,
                      color: AppColors.cardColor,
                      child: Text(
                        "Verify",
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
                          final code = _codeController.text.trim();
                          AuthCredential credential =
                              PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: code);

                          UserCredential result = await widget.auth.signInWithCredential(credential);

                          User? user = result.user;

                          stopLoading();

                          if (user != null) {
                            log("Success with : " + user.phoneNumber.toString());

                            Navigator.pop(context);
                          } else {
                            print("Error");
                          }
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.2,
                )
              ],
            ),
          ),
        ));
  }
}
