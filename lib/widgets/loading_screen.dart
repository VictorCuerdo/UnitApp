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
    return Semantics(
      label: 'This is a loading screen', // Add the semantic label here
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blueGrey, Colors.black],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LottieBuilder.asset(
                  'assets/animations/U.json',
                  width: 280,
                  height: 280,
                  fit: BoxFit.fill,
                  animate: true,
                ),
                const SizedBox(height: 15),
                RichText(
                  text: const TextSpan(
                    text: 'Unit',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Work Sans',
                      fontWeight: FontWeight.w500,
                      fontSize: 60,
                    ),
                    children: [
                      TextSpan(
                        text: 'App',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Work Sans',
                          fontWeight: FontWeight.w500,
                          fontSize: 60,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
