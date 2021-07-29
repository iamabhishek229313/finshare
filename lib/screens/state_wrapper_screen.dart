import 'package:finshare/screens/auth/login_screen.dart';
import 'package:finshare/screens/home/card_details.dart';
import 'package:finshare/screens/home/home_screen.dart';
import 'package:finshare/screens/splash/Onboardings.dart';
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
            return CardDetails();
          }
          return Onboard(); // Contains option for Google sign in.
        }); // For this time being we are triggering scrren to the startscreen .
  }
}
