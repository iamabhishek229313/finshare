import 'package:finshare/util/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController? _pageController;
  bool? _showFAB;
  List<String> _imagesURLs = [];
  List<String> _texts = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _showFAB = false;
    _imagesURLs = [];
    _texts = [];
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: _showFAB ?? false
          ? FloatingActionButton.extended(
              elevation: 10.0,
              onPressed: () async {
                // Below code will a make boolean value in the device memory saying user have
                // gone through the onboard screens.
                // SharedPreferences prefs = await SharedPreferences.getInstance();
                // prefs.setBool(AppConstants.firstUser, true).then((value) {
                //   print("Saved Preference as a value of = " + value.toString());
                // });
                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => StateWrapperScreen()));
              },
              backgroundColor: Colors.black,
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              label: Text(
                "Let's Go",
                style: TextStyle(color: Colors.white),
              ),
            )
          : null,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight * 0.8,
              child: PageView(
                controller: _pageController,
                children: List.generate(
                    _imagesURLs.length,
                    (index) => Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white10,
                                      blurRadius: 30.0, // soften the shadow
                                      spreadRadius: 0.0, //extend the shadow
                                      offset: Offset(
                                        0.0, // Move to right 10  horizontally
                                        0.0, // Move to bottom 5 Vertically
                                      ),
                                    )
                                  ],
                                ),
                                padding: EdgeInsets.all(10),
                                height: screenHeight * 0.6,
                                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                child: Image.asset(
                                  _imagesURLs[index],
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black54),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                height: screenHeight * 0.1,
                                width: screenWidth,
                                child: Center(
                                    child: Text(
                                  _texts[index],
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
                                )),
                              ),
                            ],
                          ),
                        )),
                onPageChanged: (int _pageIndex) {
                  if (_pageIndex == 3) {
                    setState(() {
                      _showFAB = true;
                    });
                  } else
                    setState(() {
                      _showFAB = false;
                    });
                },
              ),
            ),
            SizedBox(height: 32.0),
            Container(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 4,
                effect: ScaleEffect(activeDotColor: Colors.black, dotColor: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
