import 'package:finshare/screens/auth/otp_screen.dart';
import 'package:finshare/screens/auth/register_screen.dart';
import 'package:finshare/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:finshare/screens/auth/otp_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinShare',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
          primaryColor: Colors.blueGrey.shade800,
          accentColor: Colors.black,
          accentColorBrightness: Brightness.light,
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
          iconTheme: IconThemeData(color: Colors.black)),
      home: SplashScreen(),
    );
  }
}
