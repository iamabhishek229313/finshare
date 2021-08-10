import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finshare/models/invitation_modal.dart';
import 'package:finshare/models/user_data.dart';
import 'package:finshare/util/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewInvites extends StatefulWidget {
  const ViewInvites({Key? key}) : super(key: key);

  @override
  _ViewInvitesState createState() => _ViewInvitesState();
}

class _ViewInvitesState extends State<ViewInvites> with TickerProviderStateMixin {
  TabController? _tabController;

  List<String> categories = [
    "Income",
    "Housing",
    "Utilities",
    "Food",
    "Kids",
    "Clothing",
    "Donation",
    "Insurance",
    "Health care",
    "Debt",
    "Subscription",
    "Gift",
    "Medical"
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  String? _email;
  Future<String?> _getEmail() async {
    User? _user = FirebaseAuth.instance.currentUser;
    _email = (await FirebaseFirestore.instance.collection('user_ids').doc(_user?.uid).get()).get("email");
    return _email;
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 10.0,
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          tabs: [
            Tab(
                child: Text(
              'Invites',
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            )),
            Tab(
                child: Text(
              'Sent Invites',
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            )),
          ],
        ),
      ),
      body: FutureBuilder(
        future: _getEmail(),
        builder: (BuildContext context, AsyncSnapshot email) {
          if (email.hasData == false)
            return Container(
                constraints: BoxConstraints.expand(),
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                  backgroundColor: AppColors.background,
                )));
          return StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users_data').doc(email.data).snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData == false)
                return Container(
                    constraints: BoxConstraints.expand(),
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Colors.black,
                      backgroundColor: AppColors.background,
                    )));

              UserData _userData = UserData.fromJson(jsonDecode(jsonEncode(snapshot.data?.data())));

              return TabBarView(controller: _tabController, children: [
                ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 48.0),
                    itemCount: _userData.invites!.length,
                    itemBuilder: (context, index) {
                      return InvitationCard(inivited: true, hash: _userData.invites![index]);
                    }),
                ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 48.0),
                    itemCount: _userData.invitesSent!.length,
                    itemBuilder: (context, index) {
                      return InvitationCard(inivited: false, hash: _userData.invites![index]);
                    }),
              ]);
            },
          );
        },
      ),
    );
  }
}

class InvitationCard extends StatelessWidget {
  const InvitationCard({
    Key? key,
    required this.hash,
    required this.inivited,
  }) : super(key: key);

  final bool inivited;
  final String hash;

  Future<Invitation> _getInvitationData() async {
    DocumentSnapshot _ds = await FirebaseFirestore.instance.collection('invitations').doc(hash).get();
    Invitation _inv = Invitation.fromJson(jsonDecode(jsonEncode(_ds.data())));
    return _inv;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getInvitationData(),
      builder: (BuildContext context, AsyncSnapshot<Invitation> snapshot) {
        if (snapshot.hasData == false)
          return Container(
              height: MediaQuery.of(context).size.height / 15,
              width: double.maxFinite,
              child: Center(
                  child: CircularProgressIndicator(
                color: Colors.black,
                backgroundColor: AppColors.background,
              )));
        return Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0),
          child: Container(
            child: Column(
              children: [
                ListTile(
                  minVerticalPadding: 2.0,
                  dense: true,
                  leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Text("A"),
                  ),
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        snapshot.data!.from.toString() + " invited you to join",
                        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
                      ),
                      Chip(label: Text("as " + snapshot.data!.members!.category.toString())),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Card number",
                            style: TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            snapshot.data!.cardNumber.toString(),
                            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        "Transaction limits",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Per transaction limit",
                            style: TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            "\$" + snapshot.data!.members!.permissions!.perTransactionLimit.toString(),
                            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Daily limit",
                            style: TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            "\$" + snapshot.data!.members!.permissions!.dailyLimit.toString(),
                            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Monthly limit",
                            style: TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            "\$" + snapshot.data!.members!.permissions!.monthlyLimit.toString(),
                            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      (snapshot.data!.members!.category == "Others" || snapshot.data!.members!.category == "Child")
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  "Timing limits",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "From",
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                    Text(
                                      "04:35AM",
                                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "To",
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                    Text(
                                      "06:00PM",
                                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                      (snapshot.data!.members!.category == "Others")
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  "Category limit",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                Wrap(
                                    alignment: WrapAlignment.start,
                                    spacing: 4.0,
                                    children: List.generate(
                                        snapshot.data!.members!.permissions!.categories!.length,
                                        (index) => Chip(
                                            visualDensity: VisualDensity.compact,
                                            padding: EdgeInsets.zero,
                                            label: Text(snapshot.data!.members!.permissions!.categories![index])))),
                                Row(
                                  children: [
                                    Expanded(
                                        child: FlatButton(
                                            color: Colors.indigo,
                                            onPressed: () {},
                                            child: Text(
                                              "Accept",
                                              style: TextStyle(color: Colors.white),
                                            ))),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Expanded(
                                        child: OutlineButton(
                                      onPressed: () {},
                                      child: Text("Reject"),
                                    ))
                                  ],
                                )
                              ],
                            )
                          : SizedBox.shrink()
                    ],
                  ),
                ),
                Divider(
                  thickness: 0.4,
                  height: 20.0,
                  color: Colors.blueGrey[200],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
