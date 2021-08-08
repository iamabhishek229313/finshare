import 'package:finshare/models/card_data.dart';
import 'package:finshare/screens/home/card_details.dart';
import 'package:finshare/screens/home/grant_permissions.dart';
import 'package:finshare/util/colors.dart';
import 'package:finshare/util/my_svg_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multiavatar/multiavatar.dart';
import 'dart:math' as math;

class AddNewUser extends StatefulWidget {
  const AddNewUser({Key? key, required this.cardData}) : super(key: key);
  final CardData? cardData;

  @override
  _AddNewUserState createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
  int chosedPerson = -1;
  DrawableRoot? _chosedAvatar;
  String? _chosedAvatarCode;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: AppColors.background,
          title: Text(
            "Share your card",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            if (chosedPerson == -1)
              return;
            else {
              widget.cardData?.members?.add(Members(
                  addedAt: DateTime.now().microsecondsSinceEpoch,
                  avatarCode: _chosedAvatarCode,
                  permissions: null,
                  category: (chosedPerson == 0)
                      ? "Partner"
                      : (chosedPerson == 1)
                          ? "Child"
                          : "Others",
                  emailId: _emailController.text.trim(),
                  name: _nameController.text.trim(),
                  transactions: []));

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => GrantPermissions(
                        chosedPerson: chosedPerson,
                        cardData: widget.cardData,
                      )));
            }
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.075,
            color: AppColors.cardColor,
            child: Center(
              child: Text(
                "GRANT PERMISSIONS",
                style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 18.0),
              ),
            ),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 32.0),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Choose Avatar",
                          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w900),
                        ),
                        Text(
                          "Invite a member to share your card",
                          style: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        const int len = 30;
                        List<DrawableRoot?> _avatarList = [];
                        List<String?> _avatarCode = [];

                        for (int currentIndex = 0; currentIndex < len; currentIndex++) {
                          var l = new List.generate(12, (_) => math.Random().nextInt(100));
                          String svgCode = multiavatar(l.join(), trBackground: true);
                          // log(svgCode.toString());

                          DrawableRoot? _svgRoot;
                          await svg.fromSvgString(svgCode, svgCode).then((value) => _svgRoot = value);
                          _avatarList.add(_svgRoot);
                          _avatarCode.add(svgCode);
                        }

                        final mp = await showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
                          elevation: 10.0,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return Container(
                              decoration:
                                  BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(20.0)),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Choose your favourite avatar",
                                        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w900),
                                      ),
                                      SizedBox(
                                        height: 16.0,
                                      ),
                                      GridView.count(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          crossAxisCount: 5,
                                          primary: false,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          children: List.generate(
                                            _avatarList.length,
                                            (index) => _avatarList[index] == null
                                                ? SizedBox.shrink()
                                                : GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context).pop(<String, dynamic>{
                                                        "avatar": _avatarList[index],
                                                        "code": _avatarCode[index]
                                                      });
                                                    },
                                                    child: Center(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.green.shade50, shape: BoxShape.circle),
                                                        child: CustomPaint(
                                                          painter: MyPainter(_avatarList[index], Size(20.0, 20.0)),
                                                          child: Container(),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          )),
                                      SizedBox(
                                        height: 32.0,
                                      )
                                    ],
                                  )),
                            );
                          },
                        );

                        if (mp != null) {
                          setState(() {
                            _chosedAvatar = mp['avatar'];
                            _chosedAvatarCode = mp['code'];
                          });
                        }
                      },
                      child: CircleAvatar(
                        radius: screenWidth / 15,
                        child: _chosedAvatar == null
                            ? Text(
                                "A",
                                style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w900, color: Colors.black),
                              )
                            : CustomPaint(
                                painter: MyPainter(_chosedAvatar, Size(20.0, 20.0)),
                                child: Container(),
                              ),
                        backgroundColor: Colors.blue.shade100,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextField(
                  controller: _nameController,
                  cursorColor: Colors.black,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: "Name",
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextField(
                  controller: _emailController,
                  cursorColor: Colors.black,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: "Email address",
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  cursorColor: Colors.black,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                  ),
                )
              ],
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Text(
              "Choose who you want to share with",
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w900),
            ),
            SizedBox(
              height: 32.0,
            ),
            SizedBox(
              child: OutlineButton(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    chosedPerson == -1
                        ? "Choose"
                        : (chosedPerson == 0 ? "Partner" : (chosedPerson == 1 ? "Children" : "Others")),
                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700),
                  ),
                  onPressed: () async {
                    final _selectedCandidate = await showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
                      elevation: 10.0,
                      builder: (BuildContext context) {
                        return Container(
                          decoration:
                              BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(20.0)),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Choose",
                                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w900),
                                  ),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(
                                      3,
                                      (index) => SizedBox(
                                        height: (screenHeight * 0.3) / 4,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop(index);
                                          },
                                          child: Card(
                                            elevation: .5,
                                            borderOnForeground: true,
                                            shadowColor: AppColors.shadow,
                                            margin: EdgeInsets.only(top: 2.5),
                                            color: Colors.white,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: CircleAvatar(
                                                      child: Text(
                                                        "A",
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                      backgroundColor: Colors.black,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 8,
                                                    child: Text(
                                                      (index == 0) ? "Partner" : (index == 1 ? "Children" : "Others"),
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Center(
                                                        child: Icon(
                                                      (chosedPerson != index)
                                                          ? Icons.arrow_forward
                                                          : Icons.check_circle,
                                                      color:
                                                          (chosedPerson != index) ? Colors.grey : Colors.green.shade800,
                                                    )),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 32.0,
                                  )
                                ],
                              )),
                        );
                      },
                    );

                    if (_selectedCandidate != null) {
                      setState(() {
                        chosedPerson = _selectedCandidate;
                      });
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0), side: BorderSide(color: Colors.black, width: 1.5))),
            ),
          ],
        )
        // body: Container(
        //   padding: const EdgeInsets.all(32.0),
        //   color: Colors.indigo.shade200,
        //   child: Center(
        //     child: Text(
        //       "In Progress ... Next time you won't be looking into this.",
        //       style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
        //     ),
        //   ),
        // ),
        );
  }
}
