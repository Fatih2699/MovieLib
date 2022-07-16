import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:movielib/constants/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ApplicationConstants.mavi,
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Lottie.asset('assets/lottie/lottie.json'),
      ),
    );
  }
}
