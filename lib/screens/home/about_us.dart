import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:finshare/models/api_res.dart';
import 'package:finshare/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  APIRES? apires;
  // String responseText = "No response yet.";

  _getData() async {
    var headers = {
      'X-Zeta-AuthToken':
          'eyJlbmMiOiJBMTI4Q0JDLUhTMjU2IiwidGFnIjoiWHhGMWpBRzgxVTNDWkNVX2Y4R1I5USIsImFsZyI6IkExMjhHQ01LVyIsIml2IjoiaXgzSTNfNEtuU05DOFlEbCJ9.6FfhdIpQgKTUHdJftomE32F8gEc1EwVHMWBGXsXLn_s.1fdYHGueF_u2dbFUf8i2Fw.hgNRd3OuUxke2YC95n1XP3oZ2rkTEMrxMXEZ5rznAzXM1FX8X4OVP-Zdc-9nrnoetkmp9RtuQ0ulwJywntoQHxvJHpnPtVXn8Ji_FuPE2NVLmTdNoZNquID-fERsd-c_bFj4erFridHMMiZjkbOpUUP-tf5_m4o40YKvJBFSf6PHBgEOASvfHo_FvzgtCepYS7tR3RKn2tx4G0FpdXfRp5NM9qW21L7v5byA-mkKf0q8Cw7iHAUa1gTn2DN1HANa6KZTpSMjAFeJVrPO8pPEcduwGa6n6yYZObd_L2bqoKO9kFaqFuSbBqlly4yCpf9FUs0Se-Ad-rQ35dPMilj1yVT8bdU2aRVA9GjtZ7hWmBwQ-0RB9OtB91IiV4IR4DBM.x-BYWf9BTuJtFVDZLAL96g',
      'Cookie':
          'AWSALB=BPbUoxiZynYgcaZBC8vJGwrvX9edh0ha7QQha2RcO2t2D0XPA7fB08YOJGZ++CoyoUL3VvioYhTAl0yGZ/wd8QrI1c4/DPbRltW1sI5Wq+eMrhKERBTvKxlB3gdf; AWSALBCORS=BPbUoxiZynYgcaZBC8vJGwrvX9edh0ha7QQha2RcO2t2D0XPA7fB08YOJGZ++CoyoUL3VvioYhTAl0yGZ/wd8QrI1c4/DPbRltW1sI5Wq+eMrhKERBTvKxlB3gdf'
    };
    var url =
        Uri.parse('https://fusion.preprod.zeta.in/api/v1/ifi/140793/bundles/f7ee3492-f4f7-4652-9bf2-76357d1f22a2');
    await http.get(url, headers: headers).then((response) {
      log(response.body.toString());
      setState(() {
        if (response.statusCode == 200) {
          apires = APIRES.fromJson(jsonDecode(response.body));
        }
      });
    });
  }

  List<String> teamPic = [
    'assets/images/abhinav.jpg',
    'assets/images/abhishek.jpg',
    'assets/images/priyav.jpg',
    'assets/images/arsh.jpg',
    'assets/images/krishna.jpg',
  ];

  List<String> names = ["Abhinav", "Abhishek", "Priyav", "Arshdeep", "Krishna"];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.background,
        title: Text(
          "About Us",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          var headers = {
            'X-Zeta-AuthToken':
                'eyJlbmMiOiJBMTI4Q0JDLUhTMjU2IiwidGFnIjoiWHhGMWpBRzgxVTNDWkNVX2Y4R1I5USIsImFsZyI6IkExMjhHQ01LVyIsIml2IjoiaXgzSTNfNEtuU05DOFlEbCJ9.6FfhdIpQgKTUHdJftomE32F8gEc1EwVHMWBGXsXLn_s.1fdYHGueF_u2dbFUf8i2Fw.hgNRd3OuUxke2YC95n1XP3oZ2rkTEMrxMXEZ5rznAzXM1FX8X4OVP-Zdc-9nrnoetkmp9RtuQ0ulwJywntoQHxvJHpnPtVXn8Ji_FuPE2NVLmTdNoZNquID-fERsd-c_bFj4erFridHMMiZjkbOpUUP-tf5_m4o40YKvJBFSf6PHBgEOASvfHo_FvzgtCepYS7tR3RKn2tx4G0FpdXfRp5NM9qW21L7v5byA-mkKf0q8Cw7iHAUa1gTn2DN1HANa6KZTpSMjAFeJVrPO8pPEcduwGa6n6yYZObd_L2bqoKO9kFaqFuSbBqlly4yCpf9FUs0Se-Ad-rQ35dPMilj1yVT8bdU2aRVA9GjtZ7hWmBwQ-0RB9OtB91IiV4IR4DBM.x-BYWf9BTuJtFVDZLAL96g',
            'Cookie':
                'AWSALB=BPbUoxiZynYgcaZBC8vJGwrvX9edh0ha7QQha2RcO2t2D0XPA7fB08YOJGZ++CoyoUL3VvioYhTAl0yGZ/wd8QrI1c4/DPbRltW1sI5Wq+eMrhKERBTvKxlB3gdf; AWSALBCORS=BPbUoxiZynYgcaZBC8vJGwrvX9edh0ha7QQha2RcO2t2D0XPA7fB08YOJGZ++CoyoUL3VvioYhTAl0yGZ/wd8QrI1c4/DPbRltW1sI5Wq+eMrhKERBTvKxlB3gdf'
          };
          var url = Uri.parse(
              'https://fusion.preprod.zeta.in/api/v1/ifi/140793/bundles/f7ee3492-f4f7-4652-9bf2-76357d1f22a2');
          await http.get(url, headers: headers).then((response) {
            log(response.body.toString());
            setState(() {
              if (response.statusCode == 200) {
                apires = APIRES.fromJson(jsonDecode(response.body));
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data Synced")));
          });
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            Text(
              "Project Idea",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w900, color: Colors.black),
            ),
            SizedBox(
              height: 8.0,
            ),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "An app, where the cardholder can share their card to partner/family/other/ and can limit their their daily/monthly budgets and per-transaction limits. Permissions can be grantedto shared people for the requirement of consent approval from the cardholder.",
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Our team",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w900, color: Colors.black),
            ),
            SizedBox(
              height: 8.0,
            ),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                    height: screenHeight * 0.1,
                    child: ListView(
                      padding: EdgeInsets.only(right: 16.0),
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                          teamPic.length,
                          (index) => Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: screenHeight * 0.07,
                                      width: screenHeight * 0.07,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(teamPic[index]),
                                            fit: BoxFit.fill,
                                          ),
                                          shape: BoxShape.circle,
                                          color: Colors.amber),
                                    ),
                                    Text(
                                      names[index],
                                      maxLines: 3,
                                    )
                                  ],
                                ),
                              )),
                    )),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Application details",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w900, color: Colors.black),
            ),
            SizedBox(
              height: 8.0,
            ),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: apires == null
                    ? Center(
                        child: Text(
                          "Getting details ...",
                          style: TextStyle(fontSize: 14.0),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "App Info",
                                style: TextStyle(fontSize: 14.0),
                              ),
                              Text(
                                apires!.id.toString(),
                                style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Application name",
                                style: TextStyle(fontSize: 14.0),
                              ),
                              Text(
                                "FinShare",
                                style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "IFL ID",
                                style: TextStyle(fontSize: 14.0),
                              ),
                              Text(
                                apires!.ifiID.toString(),
                                style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Production ID",
                                style: TextStyle(fontSize: 14.0),
                              ),
                              Text(
                                apires!.vboID.toString(),
                                style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Last updated at",
                                style: TextStyle(fontSize: 14.0),
                              ),
                              Text(
                                apires!.updatedAt.toString(),
                                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          // Row(
                          //   children: [
                          //     Text(
                          //       "URL",
                          //       style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),
                          //     ),
                          //     SizedBox(
                          //       width: 8.0,
                          //     ),
                          //     Expanded(
                          //       child: Text(
                          //         'https://fusion.preprod.zeta.in/api/v1/ifi/140793/bundles/f7ee3492-f4f7-4652-9bf2-76357d1f22a2',
                          //         overflow: TextOverflow.ellipsis,
                          //         style: TextStyle(
                          //           color: Colors.indigo,
                          //           fontSize: 12.0,
                          //         ),
                          //       ),
                          //     )
                          //   ],
                          // ),
                          // Text(
                          //   "Response",
                          //   style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),
                          // ),
                          // SizedBox(
                          //   height: 4.0,
                          // ),
                          // Text(
                          //   apires == null ? "No response yet" : apires!.updatedAt.toString(),
                          //   style: TextStyle(
                          //     fontSize: 12.0,
                          //   ),
                          // )
                        ],
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
