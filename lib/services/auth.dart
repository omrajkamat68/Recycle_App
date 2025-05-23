import 'package:cloud_firestore/cloud_firestore.dart';
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
    
    final currentContext = context;
    
    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final UserCredential result = 
          await _firebaseAuth.signInWithCredential(credential);

      if (result.user != null) {
        final User user = result.user!;
        
        // Save user details
        await SharedpreferenceHelper().saveUserEmail(user.email!);
        await SharedpreferenceHelper().saveUserId(user.uid);
        await SharedpreferenceHelper().saveUserImage(user.photoURL ?? '');
        await SharedpreferenceHelper().saveUserName(user.displayName ?? '');

        // Check if user exists in Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        
        if (!userDoc.exists) {
          // New user - initialize with Points: "0"
          Map<String, dynamic> userInfoMap = {
            "email": user.email,
            "name": user.displayName,
            "image": user.photoURL,
            "Id": user.uid,
            "Points": "0",
          };
          await DatabaseMethods().addUserInfo(userInfoMap, user.uid);
        } else {
          // Existing user - only update profile info, NOT points
          Map<String, dynamic> updateMap = {
            "email": user.email,
            "name": user.displayName,
            "image": user.photoURL,
          };
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update(updateMap);
        }

        // Navigate to appropriate screen if context is still valid
        if (currentContext.mounted) {
          Navigator.pushReplacement(
            currentContext,
            MaterialPageRoute(builder: (context) => const BottomNav()),
          );
        }
      }
    } catch (error) {
      print("Google Sign-In Error: $error");
      if (currentContext.mounted) {
        ScaffoldMessenger.of(currentContext).showSnackBar(
          SnackBar(content: Text("Sign-In failed: ${error.toString()}")),
        );
      }
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
