import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:foster_friends/state/appState.dart';
import 'dart:convert';
import 'dart:math';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

// Only used for google users
final GoogleSignIn googleSignIn = GoogleSignIn();
String error = '';

// Email sign in methods
Future<String> emailSignIn(String email, String password) async {
  AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  FirebaseUser user = result.user;
  return user.uid;
}

Future<String> emailSignUp(String email, String password) async {
  AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
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
    final GoogleSignInAuthentication googleSignInAuthentication = await _googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    print("Finalized with credential: $credential");
    try {
      await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      print("Firebase error $e");
      return 'Firebase error';
    }
  } catch (e) {
    print('Error $e');
    return 'Google Sign In Error. Please Try Again.';
  }
  return "";
}

// Sign in method apple
String generateNonce([int length = 32]) {
  final charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
}

/// Returns the sha256 hash of [input] in hex notation.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

Future<String> signInWithApple() async {
  // To prevent replay attacks with the credential returned from Apple, we
  // include a nonce in the credential request. When signing in with
  // Firebase, the nonce in the id token returned by Apple, is expected to
  // match the sha256 hash of `rawNonce`.
  final rawNonce = generateNonce();
  final nonce = sha256ofString(rawNonce);

  try {
    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    OAuthProvider oAuthProvider = new OAuthProvider(providerId: "apple.com");
    final AuthCredential credential = oAuthProvider.getCredential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
      rawNonce: rawNonce,
    );
    print("Finalized with credential: $credential");
    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    try {
      await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      print("Firebase error $e");
      return 'Firebase error';
    }
  } catch (e) {
    print('Error $e');
    return 'Apple Sign In Error. Please Try Again.';
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
