// import 'package:flutter/material.dart';
// import 'package:recycle_app/services/auth.dart';
// import 'package:recycle_app/services/widget_support.dart';
// import 'package:recycle_app/Admin/admin_login.dart';

// class LogIn extends StatefulWidget {
//   const LogIn({super.key});

//   @override
//   State<LogIn> createState() => _LogInState();
// }

// class _LogInState extends State<LogIn> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           child: Column(
//             children: [
//               Center(
//                 child: Image.asset(
//                   "images/login.png",
//                   height: 300,
//                   width: MediaQuery.of(context).size.width,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               const SizedBox(height: 20.0),
//               Image.asset(
//                 "images/recycle1.png",
//                 height: 120,
//                 width: 120,
//                 fit: BoxFit.cover,
//               ),
//               const SizedBox(height: 20.0),
//               Text(
//                 "Reduce, Reuse, Recycle.",
//                 style: AppWidget.headlinetextstyle(25.0),
//               ),
//               Text("Repeat!", style: AppWidget.greentextstyle(32.0)),
//               const SizedBox(height: 80.0),
//               Text(
//                 "Every item you recycle\nmakes a difference!",
//                 textAlign: TextAlign.center,
//                 style: AppWidget.normaltextstyle(20.0),
//               ),
//               Text("Get Started!", style: AppWidget.greentextstyle(24.0)),
//               const SizedBox(height: 30.0),
//               GestureDetector(
//                 onTap: () {
//                   AuthMethods().signInWithGoogle(context);
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.only(left: 20.0, right: 20.0),
//                   child: Material(
//                     elevation: 4.0,
//                     borderRadius: BorderRadius.circular(20),
//                     child: Container(
//                       padding: const EdgeInsets.only(left: 20.0),
//                       height: 80,
//                       decoration: BoxDecoration(
//                         color: Colors.green,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(60),
//                             ),
//                             child: Image.asset(
//                               "images/google.png",
//                               height: 50,
//                               width: 50,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           const SizedBox(width: 20.0),
//                           Text(
//                             "Sign in with Google",
//                             style: AppWidget.whitetextstyle(25.0),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20.0),
//               // Admin Login Button
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => const AdminLogin()),
//                   );
//                 },
//                 child: Container(
//                   height: 60,
//                   margin: const EdgeInsets.symmetric(horizontal: 20.0),
//                   decoration: BoxDecoration(
//                     color: Colors.black,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Center(
//                     child: Text(
//                       "Login as Admin",
//                       style: AppWidget.whitetextstyle(20.0),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 40.0),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:recycle_app/services/auth.dart';
import 'package:recycle_app/services/widget_support.dart';
import 'package:recycle_app/Admin/admin_login.dart';

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDF6), // Subtle off-white for a clean look
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top illustration
                  Image.asset(
                    "images/login.png",
                    height: 210,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10),
                  // Recycle icon
                  Image.asset(
                    "images/recycle1.png",
                    height: 56,
                    width: 56,
                  ),
                  const SizedBox(height: 16),
                  // Headline
                  Text(
                    "Reduce, Reuse, Recycle.",
                    style: AppWidget.headlinetextstyle(24.0)?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Repeat!",
                    style: AppWidget.greentextstyle(28.0)?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  // Subtitle
                  Text(
                    "Every item you recycle\nmakes a difference!",
                    textAlign: TextAlign.center,
                    style: AppWidget.normaltextstyle(16.0),
                  ),
                  Text(
                    "Get Started!",
                    style: AppWidget.greentextstyle(18.0)?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 28),
                  // Google Sign-In Button
                  GestureDetector(
                    onTap: () {
                      AuthMethods().signInWithGoogle(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 54,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.16),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Image.asset(
                              "images/google.png",
                              height: 28,
                              width: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            "Sign in with Google",
                            style: AppWidget.whitetextstyle(20.0)?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Admin Login Button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdminLogin()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Login as Admin",
                          style: AppWidget.whitetextstyle(20.0)?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

