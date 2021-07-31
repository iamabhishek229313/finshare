import 'dart:developer';

import 'package:credit_card_input_form/constants/constanst.dart';
import 'package:credit_card_input_form/credit_card_input_form.dart';
import 'package:finshare/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

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

  // String cardNumber = '';
  // String expiryDate = '';
  // String cardHolderName = '';
  // String cvvCode = '';
  // bool isCvvFocused = false;
  // final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // void onCreditCardModelChange(CreditCardModel? creditCardModel) {
  //   setState(() {
  //     cardNumber = creditCardModel!.cardNumber;
  //     expiryDate = creditCardModel.expiryDate;
  //     cardHolderName = creditCardModel.cardHolderName;
  //     cvvCode = creditCardModel.cvvCode;
  //     isCvvFocused = creditCardModel.isCvvFocused;
  //   });
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: AppColors.background,
  //     appBar: AppBar(
  //       elevation: 0.0,
  //       backgroundColor: AppColors.background,
  //       title: Text(
  //         "Add Card",
  //         style: TextStyle(color: Colors.black),
  //       ),
  //       iconTheme: IconThemeData(color: Colors.black),
  //     ),
  //     bottomNavigationBar: Container(
  //       height: MediaQuery.of(context).size.height * 0.075,
  //       color: AppColors.cardColor,
  //       child: Center(
  //         child: Text(
  //           "ADD CARD",
  //           style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 18.0),
  //         ),
  //       ),
  //     ),
  //     body: SingleChildScrollView(
  //       child: ListView(
  //         shrinkWrap: true,
  //         children: <Widget>[
  //           CreditCardWidget(
  //             height: MediaQuery.of(context).size.height * 0.257,
  //             cardBgColor: Color.fromRGBO(28, 30, 32, 1),
  //             cardNumber: cardNumber,
  //             expiryDate: expiryDate,
  //             cardHolderName: cardHolderName,
  //             cvvCode: cvvCode,
  //             showBackView: isCvvFocused,
  //             obscureCardNumber: true,
  //             obscureCardCvv: true,
  //           ),
  //           Column(
  //             children: <Widget>[
  //               CreditCardForm(
  //                 formKey: formKey,
  //                 obscureCvv: true,
  //                 obscureNumber: true,
  //                 cardNumber: cardNumber,
  //                 cvvCode: cvvCode,
  //                 cardHolderName: cardHolderName,
  //                 expiryDate: expiryDate,
  //                 themeColor: Colors.blue,
  //                 cardNumberDecoration: const InputDecoration(
  //                   border: OutlineInputBorder(),
  //                   labelText: 'Number',
  //                   hintText: 'XXXX XXXX XXXX XXXX',
  //                 ),
  //                 expiryDateDecoration: const InputDecoration(
  //                   border: OutlineInputBorder(),
  //                   labelText: 'Expired Date',
  //                   hintText: 'XX/XX',
  //                 ),
  //                 cvvCodeDecoration: const InputDecoration(
  //                   border: OutlineInputBorder(),
  //                   labelText: 'CVV',
  //                   hintText: 'XXX',
  //                 ),
  //                 cardHolderDecoration: const InputDecoration(
  //                   border: OutlineInputBorder(),
  //                   labelText: 'Card Holder',
  //                 ),
  //                 onCreditCardModelChange: onCreditCardModelChange,
  //               ),
  //               // ElevatedButton(
  //               //   style: ElevatedButton.styleFrom(
  //               //     shape: RoundedRectangleBorder(
  //               //       borderRadius: BorderRadius.circular(8.0),
  //               //     ),
  //               //     primary: const Color(0xff1b447b),
  //               //   ),
  //               //   child: Container(
  //               //     margin: const EdgeInsets.all(8),
  //               //     child: const Text(
  //               //       'Validate',
  //               //       style: TextStyle(
  //               //         color: Colors.white,
  //               //         fontFamily: 'halter',
  //               //         fontSize: 14,
  //               //         package: 'flutter_credit_card',
  //               //       ),
  //               //     ),
  //               //   ),
  //               //   onPressed: () {
  //               //     if (formKey.currentState!.validate()) {
  //               //       print('valid!');
  //               //     } else {
  //               //       print('invalid!');
  //               //     }
  //               //   },
  //               // )
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
