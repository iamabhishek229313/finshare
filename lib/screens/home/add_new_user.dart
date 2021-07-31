import 'package:finshare/util/colors.dart';
import 'package:flutter/material.dart';

class AddNewUser extends StatefulWidget {
  const AddNewUser({Key? key}) : super(key: key);

  @override
  _AddNewUserState createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.background,
        title: Text(
          "Add new user",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        padding: const EdgeInsets.all(32.0),
        color: Colors.indigo.shade200,
        child: Center(
          child: Text(
            "In Progress ... Next time you won't be looking into this.",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
