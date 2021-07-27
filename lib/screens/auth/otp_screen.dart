import 'dart:developer';

import 'package:finshare/util/progress_indc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

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
                  style: TextStyle(fontSize: screenWidth / 7, fontWeight: FontWeight.w900, color: Colors.black),
                ),
                SizedBox(
                  height: screenHeight / 20,
                ),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
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
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 10),
                //   width: screenWidth,
                //   child: TextField(
                //     maxLength: 6,
                //     controller: _codeController,
                //     keyboardType: TextInputType.number,
                //     cursorColor: Colors.black,
                //     scrollPadding: EdgeInsets.zero,
                //     style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w900),
                //     decoration: InputDecoration(hintText: 'Enter OTP', prefixText: ""),
                //   ),
                // ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Container(
                    //   child: GestureDetector(
                    //       onTap: () {
                    //         final phone = widget.phoneNumber.trim();
                    //         loginUser(phone, context);
                    //       },
                    //       child: Text(
                    //         "Resend OTP",
                    //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.blueAccent),
                    //       )),
                    // ),
                    IconButton(
                      splashColor: Colors.white10,
                      focusColor: Colors.white10,
                      highlightColor: Colors.white10,
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () async {
                        final code = _codeController.text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: code);

                        UserCredential result = await widget.auth.signInWithCredential(credential);

                        User? user = result.user;

                        if (user != null) {
                          log("Success with : " + user.phoneNumber.toString());
                          Navigator.pop(context);
                        } else {
                          print("Error");
                        }
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
