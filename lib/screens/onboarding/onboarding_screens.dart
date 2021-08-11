import 'package:finshare/screens/auth/login_screen.dart';
import 'package:finshare/util/colors.dart';
import 'package:finshare/util/constants.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageModelData {
  final String image_url;
  final String title;
  final String sub_title;

  PageModelData(this.image_url, this.title, this.sub_title);
}

class Onboard extends StatefulWidget {
  Onboard({Key? key}) : super(key: key);

  @override
  _OnboardState createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  List<PageModelData> _screens = [
    PageModelData('assets/images/credit8.png', 'Share Cards with Family',
        'With FinShare, share your credit and debit cards with your near ones for easy and clean flow of family finances'),
    PageModelData('assets/images/credit8.png', 'Share Cards with Family',
        'With FinShare, share your credit and debit cards with your near ones for easy and clean flow of family finances'),
    PageModelData('assets/images/credit8.png', 'Share Cards with Family',
        'With FinShare, share your credit and debit cards with your near ones for easy and clean flow of family finances')
  ];

  var onboardingPagesList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    onboardingPagesList = List.generate(
      _screens.length,
      (index) => PageModel(
        widget: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: Image.asset(
                    _screens[index].image_url,
                    fit: BoxFit.cover,
                  )),
                ],
              ),
              Column(
                children: [
                  Text(
                    _screens[index].title,
                    style: TextStyle(fontSize: 28.0, color: Colors.black, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    _screens[index].sub_title,
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    textAlign: TextAlign.center,
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
    );

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
          proceedButtonRoute: (context) async {
            SharedPreferences _prefs = await SharedPreferences.getInstance();
            _prefs.setBool(AppConstants.firstUser, false);
            Phoenix.rebirth(context);
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
