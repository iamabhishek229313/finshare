import 'package:finshare/screens/auth/login_screen.dart';
import 'package:finshare/util/colors.dart';
import 'package:onboarding/onboarding.dart';
import 'package:flutter/material.dart';

class Onboard extends StatelessWidget {
  const Onboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onboardingPagesList = [
      PageModel(
        widget: Container(
          color: Colors.grey,
          padding: EdgeInsets.only(top: 45.0, left: 45.0, right: 45.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: Image.asset(
                    'assets/images/credit8.png',
                  )),
                ],
              ),
              Column(
                children: [
                  Container(
                      width: double.infinity,
                      child: Text(
                        'Share Cards with Family',
                        style: pageTitleStyle,
                        textAlign: TextAlign.center,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      'With FinShare, share your credit and debit cards with your near ones for easy and clean flow of family finances',
                      style: pageInfoStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      PageModel(
        widget: Container(
          color: Colors.grey[800],
          padding: EdgeInsets.only(top: 45.0, left: 45.0, right: 45.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: Image.asset(
                    'assets/images/credit8.png',
                  )),
                ],
              ),
              Column(
                children: [
                  Container(
                      width: double.infinity,
                      child: Text(
                        'Share Cards with Family',
                        style: pageTitleStyle,
                        textAlign: TextAlign.center,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      'With FinShare, share your credit and debit cards with your near ones for easy and clean flow of family finances',
                      style: pageInfoStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      PageModel(
        widget: Container(
          color: Colors.black,
          padding: EdgeInsets.only(top: 45.0, left: 45.0, right: 45.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: Image.asset(
                    'assets/images/credit8.png',
                  )),
                ],
              ),
              Column(
                children: [
                  Container(
                      width: double.infinity,
                      child: Text(
                        'Share Cards with Family',
                        style: pageTitleStyle,
                        textAlign: TextAlign.center,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      'With FinShare, share your credit and debit cards with your near ones for easy and clean flow of family finances',
                      style: pageInfoStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];
    return Onboarding(
      skipButtonStyle: SkipButtonStyle(
          skipButtonText: Text("skip"),
          skipButtonColor: AppColors.background,
          skipButtonBorderRadius: BorderRadius.circular(5)),
      pagesContentPadding: EdgeInsets.all(0),
      proceedButtonStyle: ProceedButtonStyle(
          proceedpButtonText: Text("Continue"),
          proceedButtonColor: AppColors.background,
          proceedButtonBorderRadius: BorderRadius.circular(5),
          proceedButtonRoute: (context) {
            return Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => Login(),
              ),
              (route) => false,
            );
          }),
      pages: onboardingPagesList,
      footerPadding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 20.0),
      isSkippable: true,
      background: AppColors.text,
      indicator: Indicator(
        indicatorDesign: IndicatorDesign.line(
          lineDesign: LineDesign(
            lineType: DesignType.line_uniform,
          ),
        ),
      ),
    );
  }
}
