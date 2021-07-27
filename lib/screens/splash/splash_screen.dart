import 'package:finshare/screens/state_wrapper_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => StateWrapperScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
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
      )),
    );
  }
}
