import 'package:flutter/material.dart';
import 'package:movielib/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pagecontroller = PageController();
  bool isLastPage = false;
  @override
  void dispose() {
    _pagecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pagecontroller,
        onPageChanged: (index) {
          setState(() => isLastPage = index == 1);
        },
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    opacity: 1,
                    fit: BoxFit.cover,
                    image: Image.asset(
                      'assets/images/background.png',
                    ).image,
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 4, //200,
                width: MediaQuery.of(context).size.width / 1, //500,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.asset(
                      'assets/images/name.png',
                    ).image,
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 1,
                width: MediaQuery.of(context).size.height / 1,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.asset(
                      'assets/images/cinema.png',
                    ).image,
                  ),
                ),
              ),
              const Positioned(
                bottom: 120,
                left: 80,
                right: 80,
                child: Text(
                  'Filmlerin,fragmanlarını ve\nIMDB puanlarını gör!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            ],
          ),
          Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    opacity: 1,
                    fit: BoxFit.cover,
                    image: Image.asset(
                      'assets/images/background.png',
                    ).image,
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 4, //200,
                width: MediaQuery.of(context).size.width / 1, //500,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.asset(
                      'assets/images/name.png',
                    ).image,
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 1,
                width: MediaQuery.of(context).size.height / 1,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.asset(
                      'assets/images/comment.png',
                    ).image,
                  ),
                ),
              ),
              const Positioned(
                bottom: 120,
                left: 80,
                right: 80,
                child: Text(
                  'Beğendiğin filmleri puanla ve favorilerine ekle!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            ],
          )
        ],
      ),
      bottomSheet: isLastPage
          ? Container(
              color: const Color(0XFF04103A),
              child: TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('showHome', true);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Uygulama Geç!',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0XFF04103A),
                  minimumSize: const Size.fromHeight(100),
                ),
              ),
            )
          : Container(
              color: const Color(0XFF04103A),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height / 13.3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () => _pagecontroller.jumpToPage(2),
                    child: const Text(
                      'Geç',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      count: 2,
                      controller: _pagecontroller,
                      effect: const WormEffect(
                        spacing: 30,
                        dotColor: Colors.grey,
                        activeDotColor: Colors.white,
                      ),
                      onDotClicked: (index) => _pagecontroller.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn),
                    ),
                  ),
                  TextButton(
                      onPressed: () => _pagecontroller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
    );
  }

  Container buildPage(
      {required color, required urlImage, required title, required subtitle}) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            urlImage,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 24,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              subtitle,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
