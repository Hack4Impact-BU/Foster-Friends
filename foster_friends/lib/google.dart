import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String name;
String email;
String imageUrl;

String error;

Future<String> signInWithGoogle() async {
  print('In signInWithGoogle');
  GoogleSignInAccount _googleSignInAccount;
  try {
    _googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await _googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    await _auth.signInWithCredential(credential);
  } catch (e) {
    print('Error $e');
    error = 'Google Sign In Error. Please Try Again.';
  }

  return error;
}

void signOutGoogle() async {
  await googleSignIn.signOut();
  await FirebaseAuth.instance.signOut();
  print("User Sign Out");
}
