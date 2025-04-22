import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recycle_app/pages/home.dart';
import 'package:recycle_app/services/database.dart';
import 'package:recycle_app/services/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethods {
  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication?.idToken,
      accessToken: googleSignInAuthentication?.accessToken,
    );

    UserCredential result = await firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;

    await SharedpreferenceHelper().saveUserEmail(userDetails!.email!);
    await SharedpreferenceHelper().saveUserId(userDetails.uid);
    await SharedpreferenceHelper().saveUserImage(userDetails.photoURL!);
    await SharedpreferenceHelper().saveUserName(userDetails.displayName!);

    if (result != null) {
      Map<String, dynamic> userInfoMap = {
        "email": userDetails!.email,
        "name": userDetails.displayName,
        "image": userDetails.photoURL,
        "Id": userDetails.uid,
      };

      await DatabaseMethods().addUserInfo(userInfoMap, userDetails.uid);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
  }
}
