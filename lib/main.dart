import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recycle_app/Admin/admin_approval.dart';
import 'package:recycle_app/Admin/admin_login.dart';
import 'package:recycle_app/Admin/admin_reedem.dart';
import 'package:recycle_app/pages/bottomnav.dart';
import 'package:recycle_app/pages/home.dart';
import 'package:recycle_app/pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recycle App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Show loading indicator while checking auth state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          
          // User is logged in
          if (snapshot.hasData) {
            // Add your logic here to check admin status if needed
            return const BottomNav(); // Default user home
          }
          
          // User is not logged in
          return const LogIn();
        },
      ),
      routes: {
        '/admin/login': (context) => const AdminLogin(),
        '/user/home': (context) => const Home(),
        '/admin/approval': (context) => const AdminApproval(),
        '/admin/redeem': (context) => const AdminReedem(),
      },
    );
  }
}
