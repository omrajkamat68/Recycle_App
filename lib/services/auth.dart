import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recycle_app/pages/bottomnav.dart';
import 'package:recycle_app/services/database.dart';
import 'package:recycle_app/services/shared_pref.dart';

class AuthMethods {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Force account selection by signing out first
      await _googleSignIn.signOut();

      // Initiate Google Sign-In with account selection
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      // Get authentication details
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      // Create Firebase credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Sign in to Firebase
      final UserCredential result = 
          await _firebaseAuth.signInWithCredential(credential);

      // Handle user data
      if (result.user != null) {
        final User user = result.user!;
        
        // Save user details
        await SharedpreferenceHelper().saveUserEmail(user.email!);
        await SharedpreferenceHelper().saveUserId(user.uid);
        await SharedpreferenceHelper().saveUserImage(user.photoURL ?? '');
        await SharedpreferenceHelper().saveUserName(user.displayName ?? '');

        // Update user info in Firestore
        Map<String, dynamic> userInfoMap = {
          "email": user.email,
          "name": user.displayName,
          "image": user.photoURL,
          "Id": user.uid,
          "Points": "0",
        };

        await DatabaseMethods().addUserInfo(userInfoMap, user.uid);

        // Navigate to appropriate screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            // Add your admin check logic here
            // if (isAdmin) return HomeAdmin();
            return const BottomNav();
          }),
        );
      }
    } catch (error) {
      print("Google Sign-In Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-In failed: ${error.toString()}")),
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      await _googleSignIn.disconnect();
      await SharedpreferenceHelper().clearAllPreferences();
    } catch (error) {
      print("Sign-Out Error: $error");
    }
  }

  Future<void> deleteUser() async {
    try {
      await _firebaseAuth.currentUser?.delete();
      await signOut();
    } catch (error) {
      print("Account Deletion Error: $error");
    }
  }
}
