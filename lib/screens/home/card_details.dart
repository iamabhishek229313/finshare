import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chart_components/bar_chart_component.dart';
import 'package:finshare/screens/home/add_credit_card.dart';
import 'package:finshare/screens/home/user_details.dart';
import 'package:finshare/util/colors.dart';
import 'package:finshare/util/data_repo.dart';
import 'package:finshare/util/my_credit_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CardDetails extends StatefulWidget {
  const CardDetails({Key? key}) : super(key: key);

  @override
  _CardDetailsState createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  List<double> data = [];
  List<String> labels = [];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    DataRepository.clearData();
    _loadData();
  }

  void _loadData() {
    setState(() {
      if (!loaded) {
        data = DataRepository.getData();
        loaded = true;
      } else {
        data[data.length - 1] = (math.Random().nextDouble() * 700).round() / 100;
      }
      labels = DataRepository.getLabels();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      // drawer: Drawer(
      //   child: Column(
      //     children: [
      //       UserAccountsDrawerHeader(accountName: Text("admin"), accountEmail: Text("admin@gmail.com")),
      //       ListTile(
      //         dense: true,
      //         tileColor: Colors.blueGrey[100],
      //         leading: Icon(Icons.logout),
      //         title: Text("Logout"),
      //         subtitle: Text("Logout from this device"),
      //         onTap: () async {
      //           await FirebaseAuth.instance.signOut().then((value) => log("singed out : "));
      //         },
      //       ),
      //       ListTile(
      //         dense: true,
      //         tileColor: Colors.blueGrey[100],
      //         leading: Icon(Icons.logout),
      //         title: Text("My Cards"),
      //         subtitle: Text("View your all added cards"),
      //         onTap: () async {
      //           Navigator.of(context).push(MaterialPageRoute(builder: (_) => MyCards()));
      //         },
      //       )
      //     ],
      //   ),
      // ),
      // appBar: AppBar(
      //   backgroundColor: AppColors.background,
      //   elevation: 0.0,
      //   iconTheme: IconThemeData(color: Colors.black),
      //   actions: [IconButton(onPressed: _loadData, icon: Icon(Icons.refresh_outlined))],
      // ),
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 44),
          children: [
            MyCreditCard(),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            SizedBox(
              height: screenWidth / 4.5,
              child: ListView.builder(
                  padding: const EdgeInsets.only(right: 16.0),
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => UserDetails()));
                      },
                      child: Container(
                        height: screenWidth / 4.5,
                        width: screenWidth / 4.5,
                        margin: EdgeInsets.only(left: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  child: Text(
                                    "A",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.black,
                                ),
                                Text(
                                  "Aztlan",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 16.0,
            ),
            SizedBox(
              height: screenHeight * 0.1,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 16.0, right: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Card balance",
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Text(
                              "\$1,804.3",
                              style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w900),
                            ),
                            Text(
                              "\$16,804.3 available",
                              style: TextStyle(fontSize: 11.0, color: Colors.grey, fontWeight: FontWeight.w900),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 8.0, right: 16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Permissions",
                              style: TextStyle(fontSize: 16.0),
                            ),
                            FloatingActionButton.extended(
                                elevation: 0.0, onPressed: () {}, label: Icon(Icons.arrow_forward))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              height: screenHeight * 0.32,
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.only(bottom: 0, left: 8, right: 8, top: 8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Spending",
                    style: TextStyle(fontSize: 12.0, color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "\$1,804.3",
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w900),
                  ),
                  Expanded(
                    child: BarChart(
                      data: data,
                      labels: labels,
                      labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      valueStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                      displayValue: true,
                      reverse: true,
                      getColor: DataRepository.getColor,
                      // getIcon: DataRepository.getIcon,
                      barWidth: 24,
                      barSeparation: 14,
                      animationDuration: Duration(milliseconds: 800),
                      animationCurve: Curves.easeInOutSine,
                      itemRadius: 3.5,
                      iconHeight: 22,
                      footerHeight: 24,
                      headerValueHeight: 16,
                      roundValuesOnText: false,
                      lineGridColor: AppColors.background,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Latest Transactions",
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w900, color: AppColors.text),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  ListBody(
                    children: List.generate(
                        10,
                        (index) => TransactionCard(
                              title: "La Colombe Coffee",
                              subTitle: "\$18.50",
                              leading: CircleAvatar(
                                child: Text(
                                  "A",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.black,
                              ),
                              time: "Yesterday",
                              onPressed: () {},
                            )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.onPressed,
    required this.leading,
    required this.time,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final Function onPressed;
  final Widget leading;
  final String time;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight * 0.09,
      child: Card(
        elevation: .2,
        shadowColor: AppColors.shadow,
        margin: EdgeInsets.only(top: 2.5),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(flex: 2, child: this.leading),
              Expanded(
                  flex: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            this.title,
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w900, color: AppColors.text),
                          ),
                          Text(
                            this.subTitle,
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Chicago, IL",
                                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: Colors.grey),
                              ),
                              Text(
                                this.time,
                                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: Colors.grey),
                              ),
                            ],
                          ),
                          Text(
                            "2%",
                            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  )),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    this.onPressed;
                  },
                  child: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.grey.shade400,
                    size: 22,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
