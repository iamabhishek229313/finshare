import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finshare/screens/auth/login_screen.dart';
import 'package:finshare/screens/auth/register_screen.dart';
import 'package:finshare/screens/home/card_details.dart';
import 'package:finshare/screens/home/home_screen.dart';
import 'package:finshare/util/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class StateWrapperScreen extends StatefulWidget {
  const StateWrapperScreen({Key? key}) : super(key: key);

  @override
  _StateWrapperScreenState createState() => _StateWrapperScreenState();
}

class _StateWrapperScreenState extends State<StateWrapperScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          print("Snapshot Data is : " + snapshot.data.toString());
          if (snapshot.hasData) {
            return Verification();
          }
          return Login();
        });
  }
}

class Verification extends StatefulWidget {
  const Verification({Key? key}) : super(key: key);

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  Future<bool> _isRegistered() async {
    User? _user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot _docSnp = await FirebaseFirestore.instance.collection('user_ids').doc(_user?.uid.toString()).get();
    log("Checking for verification :" + _docSnp.exists.toString());
    return _docSnp.exists;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _isRegistered(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == true)
            return Home();
          else
            return Register();
        }
        return Container(
          constraints: BoxConstraints.expand(),
          color: AppColors.background,
        );
      },
    );
  }
}
