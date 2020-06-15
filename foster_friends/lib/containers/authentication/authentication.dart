import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:foster_friends/state/appState.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

// Only used for google users
final GoogleSignIn googleSignIn = GoogleSignIn();
String error = '';

// Email sign in methods
Future<String> emailSignIn(String email, String password) async {
  AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
      email: email, password: password);
  FirebaseUser user = result.user;
  return user.uid;
}

Future<String> emailSignUp(String email, String password) async {
  AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email, password: password);
  FirebaseUser user = result.user;
  return user.uid;
}

Future<FirebaseUser> getCurrentUser() async {
  return await _firebaseAuth.currentUser();
}

Future<void> emailSignOut() async {
  return _firebaseAuth.signOut();
}

Future<void> sendEmailVerification() async {
  FirebaseUser user = await _firebaseAuth.currentUser();
  user.sendEmailVerification();
}

Future<bool> isEmailVerified() async {
  FirebaseUser user = await _firebaseAuth.currentUser();
  return user.isEmailVerified;
}

// Sign in method google
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
    print("Finalied with credential: $credential");
    try {
      await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      print("Firebase error $e");
      return 'Firebase error';
    };

  } catch (e) {
    print('Error $e');
    return 'Google Sign In Error. Please Try Again.';
  }
  return "";
}

// Handles both sign outs
Future<void> signOut() async {
  await googleSignIn.signOut();
  await FirebaseAuth.instance.signOut();
  //store.state.userType = '';
  print("User Sign Out");
  store.dispatch(getFirebaseUser);
}
