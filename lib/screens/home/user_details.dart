import 'dart:developer';

import 'package:chart_components/bar_chart_component.dart';
import 'package:finshare/screens/home/all_transactions.dart';
import 'package:finshare/util/colors.dart';
import 'package:finshare/util/data_repo.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: AppColors.background,
        elevation: 0.0,
        actions: [IconButton(onPressed: _loadData, icon: Icon(Icons.refresh_outlined))],
      ),
      body: ListView(
        children: [
          Container(
            height: screenHeight * 0.27,
            // color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: screenWidth / 8,
                  child: Text(
                    "A",
                    style: TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  backgroundColor: Colors.blue.shade100,
                ),
                SizedBox(
                  height: screenHeight * 0.005,
                ),
                Text(
                  "Aztlan Rico",
                  style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w900),
                ),
                Text(
                  "8 transactions",
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.grey),
                )
              ],
            ),
          ),
          Container(
            height: screenHeight * 0.32,
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.only(bottom: 0, left: 8, right: 8, top: 8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Aztlan's Spending",
                  style: TextStyle(fontSize: 12.0, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                Text(
                  "\$167.59",
                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w900),
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
            child: SizedBox(
              height: screenHeight * 0.09,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => AllTransactions()));
                },
                child: Card(
                  elevation: .2,
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "All transactions",
                                      style:
                                          TextStyle(fontSize: 18.0, fontWeight: FontWeight.w900, color: AppColors.text),
                                    ),
                                    Text(
                                      "+\$3.68",
                                      style:
                                          TextStyle(fontSize: 18.0, fontWeight: FontWeight.w900, color: AppColors.text),
                                    ),
                                  ],
                                ),
                                Text(
                                  "8 transactions",
                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.grey),
                                ),
                              ],
                            )),
                        Expanded(
                          child: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.grey.shade400,
                            size: 22,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
