import 'package:finshare/util/colors.dart';
import 'package:flutter/material.dart';

class AddNewUser extends StatefulWidget {
  const AddNewUser({Key? key}) : super(key: key);

  @override
  _AddNewUserState createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
  int chosedPerson = -1;

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
              // [do something]
            }
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.075,
            color: AppColors.cardColor,
            child: Center(
              child: Text(
                "INVITE",
                style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 18.0),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Choose Person",
                    style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    "Invite a member to share your card",
                    style: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  TextField(
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
                "Choose an avatar",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: 32.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: screenWidth / 10,
                    child: Text(
                      "A",
                      style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w900, color: Colors.black),
                    ),
                    backgroundColor: Colors.blue.shade100,
                  ),
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
                child: FlatButton(
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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
                                                          child: (chosedPerson != index)
                                                              ? SizedBox.shrink()
                                                              : Icon(
                                                                  Icons.check_circle,
                                                                  color: Colors.green.shade800,
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
          ),
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
