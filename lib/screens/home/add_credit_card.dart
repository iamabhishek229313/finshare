import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_card_input_form/constants/constanst.dart';
import 'package:credit_card_input_form/credit_card_input_form.dart';
import 'package:finshare/models/card_data.dart';
import 'package:finshare/models/email.dart';
import 'package:finshare/models/user_data.dart';
import 'package:finshare/util/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AddCreditCard extends StatefulWidget {
  const AddCreditCard({Key? key}) : super(key: key);

  @override
  _AddCreditCardState createState() => _AddCreditCardState();
}

class _AddCreditCardState extends State<AddCreditCard> {
// translate and customize captions
  final Map<String, String> customCaptions = {
    'PREV': 'Prev',
    'NEXT': 'Next',
    'DONE': 'Done',
    'CARD_NUMBER': 'Card Number',
    'CARDHOLDER_NAME': 'Cardholder Name',
    'VALID_THRU': 'Valid Thru',
    'SECURITY_CODE_CVC': 'Security Code (CVC)',
    'NAME_SURNAME': 'Name Surname',
    'MM_YY': 'MM/YY',
    'RESET': 'Reset',
  };

  final _buttonStyle =
      BoxDecoration(borderRadius: BorderRadius.circular(7.0), shape: BoxShape.rectangle, color: Colors.black);

  final cardDecoration = BoxDecoration(
      boxShadow: <BoxShadow>[BoxShadow(color: Colors.black54, blurRadius: 15.0, offset: Offset(0, 8))],
      gradient: LinearGradient(
          colors: [
            AppColors.cardColor,
            AppColors.cardColor,
            AppColors.cardColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.4, 1.0],
          tileMode: TileMode.clamp),
      borderRadius: BorderRadius.all(Radius.circular(15)));

  final buttonTextStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18);

  @override
  void initState() {
    super.initState();
  }

  _addCreditCard(String cardInfo) async {
    User? _user = FirebaseAuth.instance.currentUser;

    String? _email = (await FirebaseFirestore.instance.collection('user_ids').doc(_user?.uid).get()).get("email");

    List<String> _data = cardInfo.split(',').toList();
    for (int i = 0; i < _data.length; i++) {
      _data[i] = _data[i].split('=')[1];
    }

    CardData _cardData = CardData(
      cARDNUMBER: _data[0],
      cARDHOLDERNAME: _data[1].toUpperCase(),
      sECURITYCODECVC: int.parse(_data[3]),
      vALIDTHRU: _data[2],
      bANKNAME: "Imperial Bank",
      tYPE: "VISA",
      aVAILBALANCE: 1000.01,
      allTransactions: [],
      members: [],
    );

    await FirebaseFirestore.instance.collection('cards').doc(_data[0]).set(_cardData.toJson());
    DocumentSnapshot _ds = await FirebaseFirestore.instance.collection('users_data').doc(_email?.trim()).get();
    UserData _userData = UserData.fromJson(jsonDecode(jsonEncode(_ds.data())));
    log("getData:" + _userData.toJson().toString());
    _userData.cards?.add(_data[0]);
    log("setData:" + _userData.toJson().toString());
    await FirebaseFirestore.instance.collection('users_data').doc(_email?.trim()).update(_userData.toJson());
    log("Card added!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.background,
        title: Text(
          "Add Card",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AnimatedContainer(
            margin: const EdgeInsets.only(top: 16.0, bottom: 24.0),
            duration: Duration(milliseconds: 300),
            child: Stack(children: [
              CreditCardInputForm(
                showResetButton: false,
                onStateChange: (currentState, cardInfo) {
                  log(currentState.toString());
                  log(cardInfo.toString());

                  if (currentState == InputState.DONE) {
                    log("It's done now!");
                    _addCreditCard(cardInfo.toString());
                    Navigator.of(context).pop();
                  }
                },
                cardHeight: MediaQuery.of(context).size.height * 0.28,
                initialAutoFocus: false,
                customCaptions: customCaptions,
                cardCVV: '',
                cardName: '',
                cardNumber: '',
                cardValid: '',
                intialCardState: InputState.NUMBER,
                frontCardDecoration: cardDecoration,
                backCardDecoration: cardDecoration,
                prevButtonDecoration: _buttonStyle,
                nextButtonDecoration: _buttonStyle,
                resetButtonDecoration: _buttonStyle,
                prevButtonTextStyle: buttonTextStyle,
                nextButtonTextStyle: buttonTextStyle,
                resetButtonTextStyle: buttonTextStyle,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
