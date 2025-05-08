import 'package:flutter/material.dart';
import 'package:recycle_app/services/widget_support.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 20.0,
            ),
            child: Column(
              children: [
                SizedBox(height: 30.0),
                Image.asset("images/onboard.png"),
                SizedBox(height: 40.0),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Recycle your waste products!",
                    style: AppWidget.headlinetextstyle(32.0),
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Easily collect household waste and generate less waste",
                    style: AppWidget.normaltextstyle(18.0),
                  ),
                ),
                SizedBox(height: 60.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Center(
                        child: Text(
                          "Get Started",
                          style: AppWidget.whitetextstyle(20.0),
                        ),
                      ),
                    ),
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
