// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'unit_conversion.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHomePage();
  }

  _navigateToHomePage() async {
    await Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const UnitConversion()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF015480),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LottieBuilder.asset(
              'assets/animations/U.json',
              // You can adjust the width and height as per your requirements.
              width: 500,
              height: 500,
              fit: BoxFit.fill,
              animate: true, // True by default
            ),
            const SizedBox(
                height: 15), // Space between the animation and the text
            const Text(
              'UnitApp',
              style: TextStyle(
                color: Colors.lightBlue,
                fontWeight: FontWeight.bold,
                fontSize: 38, // Adjust the font size as per your requirements
              ),
            )
          ],
        ),
      ),
    );
  }
}
