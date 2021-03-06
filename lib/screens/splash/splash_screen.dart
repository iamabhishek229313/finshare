import 'dart:async';
import 'dart:developer';
import 'package:finshare/screens/onboarding/onboarding_screens.dart';
import 'package:finshare/screens/state_wrapper_screen.dart';
import 'package:finshare/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  _jumpToScreen(bool isfirstTime) {
    log("Is first time? " + (!isfirstTime).toString());
    Timer(
        Duration(milliseconds: 800),
        () => Navigator.pushReplacement(
            // as of now we're going for only stateWrapper screen.
            context,
            MaterialPageRoute(builder: (_) => isfirstTime == true ? Onboard() : StateWrapperScreen())));
  }

  Future<dynamic> _fetchFirstTimeState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool(AppConstants.firstUser) ?? true;
    return _jumpToScreen(isFirstTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: _fetchFirstTimeState(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Fin",
                style: TextStyle(fontSize: 56.0, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Text(
                "Share",
                style: TextStyle(fontSize: 56.0, color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ],
          ));
        },
      ),
    );
  }
}
