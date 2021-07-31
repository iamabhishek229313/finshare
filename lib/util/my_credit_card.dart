import 'package:flutter/material.dart';

class MyCreditCard extends StatelessWidget {
  const MyCreditCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        height: screenHeight * 0.285,
        margin: EdgeInsets.all(16.0),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(7), color: Color.fromRGBO(28, 30, 32, 1), boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 12.0,
            spreadRadius: 0.2,
            offset: Offset(
              3.0, // horizontal, move right 10
              3.0, // vertical, move down 10
            ),
          )
        ]),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Remote Allowance",
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16.0),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "\$307.96",
                              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 28.0),
                              children: const <TextSpan>[
                                TextSpan(
                                    text: '/\$1,0000',
                                    style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white, fontSize: 12.0)),
                              ],
                            ),
                          ),
                          Text(
                            "Balance \$USD",
                            style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white, fontSize: 10.0),
                          ),
                        ],
                      ),
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
            )));
  }
}
