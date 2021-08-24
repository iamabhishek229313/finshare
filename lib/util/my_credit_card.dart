import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finshare/models/card_data.dart';
import 'package:finshare/util/colors.dart';
import 'package:flutter/material.dart';

class MyCreditCard extends StatefulWidget {
  const MyCreditCard(
      {Key? key, required this.card_number, required this.shadow, required this.startColor, required this.endColor})
      : super(key: key);

  final String? card_number;
  final Color shadow;
  final Color startColor;
  final Color endColor;

  @override
  _MyCreditCardState createState() => _MyCreditCardState();
}

class _MyCreditCardState extends State<MyCreditCard> {
  Future<CardData> _getCard() async {
    DocumentSnapshot _ds = await FirebaseFirestore.instance.collection('cards').doc(widget.card_number).get();
    CardData _cardData = CardData.fromJson(jsonDecode(jsonEncode(_ds.data())));
    return _cardData;
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.285,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.amber,
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [widget.startColor, widget.endColor],
              stops: [0.0, 1.0]),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 12.0,
              spreadRadius: 0.2,
              offset: Offset(
                3.0, // horizontal, move right 10
                3.0, // vertical, move down 10
              ),
            )
          ]),
      child: FutureBuilder(
        future: _getCard(),
        builder: (BuildContext context, AsyncSnapshot<CardData> snapshot) {
          if (snapshot.hasData == false)
            return Container(
                constraints: BoxConstraints.expand(),
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.white38,
                  backgroundColor: Colors.transparent,
                )));
          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: "\$307.96",
                                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 28.0),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "/\$" + (snapshot.data?.aVAILBALANCE.toString() ?? ""),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400, color: Colors.white, fontSize: 12.0)),
                                  ],
                                ),
                              ),
                              Text(
                                "Balance \$USD",
                                style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white, fontSize: 10.0),
                              ),
                            ],
                          ),
                          Text(
                            "VISA",
                            style: TextStyle(
                                decorationStyle: TextDecorationStyle.wavy,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                fontSize: 22.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data?.cARDHOLDERNAME ?? "",
                              style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white, fontSize: 14.0),
                            ),
                            Text(
                              snapshot.data?.cARDNUMBER ?? "",
                              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "12/26",
                            style: TextStyle(
                                decorationStyle: TextDecorationStyle.wavy,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 16.0),
                          ),
                          Text(
                            "EXPIRY",
                            style: TextStyle(
                                decorationStyle: TextDecorationStyle.wavy,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                fontSize: 8.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ));
        },
      ),
    );
  }
}
