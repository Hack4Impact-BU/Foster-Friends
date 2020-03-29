
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Methods associated with google sign in

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String name;
String email;
String imageUrl;

Future<String> signInWithGoogle() async {
  print('In signInWithGoogle');
  GoogleSignIn _googleSignIn = GoogleSignIn();

  try {
    print('Trying to sign in');
    await _googleSignIn.signIn();
    
  } catch (error){
    print('Cry');
    print(error);
  }
  print('Awaiting google sign in');



  // final GoogleSignInAuthentication googleSignInAuthentication =
  //     await googleSignInAccount.authentication;

  // final AuthCredential credential = GoogleAuthProvider.getCredential(
  //   accessToken: googleSignInAuthentication.accessToken,
  //   idToken: googleSignInAuthentication.idToken,
  // );
  // print('The credential is');
  // print(credential);

  // final AuthResult authResult = await _auth.signInWithCredential(credential);
  // final FirebaseUser user = authResult.user;

  // // Checking if email and name is null
  // assert(user.email != null);
  // assert(user.displayName != null);
  // assert(user.photoUrl != null);

  // name = user.displayName;
  // email = user.email;
  // imageUrl = user.photoUrl;

  // // Only taking the first part of the name, i.e., First Name
  // if (name.contains(" ")) {
  //   name = name.substring(0, name.indexOf(" "));
  // }

  // assert(!user.isAnonymous);
  // assert(await user.getIdToken() != null);

  // final FirebaseUser currentUser = await _auth.currentUser();
  // assert(user.uid == currentUser.uid);

  // return 'signInWithGoogle succeeded: $user';
}

void signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Sign Out");
}