import 'package:flutter/material.dart';
import 'package:recycle_app/services/auth.dart';
import 'package:recycle_app/services/widget_support.dart';
import 'package:recycle_app/Admin/admin_login.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  "images/login.png",
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20.0),
              Image.asset(
                "images/recycle1.png",
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20.0),
              Text(
                "Reduce, Reuse, Recycle.",
                style: AppWidget.headlinetextstyle(25.0),
              ),
              Text("Repeat!", style: AppWidget.greentextstyle(32.0)),
              const SizedBox(height: 80.0),
              Text(
                "Every item you recycle\nmakes a difference!",
                textAlign: TextAlign.center,
                style: AppWidget.normaltextstyle(20.0),
              ),
              Text("Get Started!", style: AppWidget.greentextstyle(24.0)),
              const SizedBox(height: 30.0),
              GestureDetector(
                onTap: () {
                  AuthMethods().signInWithGoogle(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.only(left: 20.0),
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Image.asset(
                              "images/google.png",
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Text(
                            "Sign in with Google",
                            style: AppWidget.whitetextstyle(25.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              // Admin Login Button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminLogin()),
                  );
                },
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "Login as Admin",
                      style: AppWidget.whitetextstyle(20.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }
}