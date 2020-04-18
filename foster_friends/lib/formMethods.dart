import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foster_friends/authentication.dart';

void pushIndividualProfile(String userID, String phoneNumber, String email,
    String location, String name) async {
  DocumentReference ref =
      Firestore.instance.collection("individuals").document(userID);

  await ref.setData({
    "email": email,
    "phone number": phoneNumber,
    "location": location,
    "name": name
  });
  print("User profile submitted");
}

void pushOrganizationProfile(String userID, String address, String description,
    String email, String name, String phoneNumber, String photoLink) async {
  DocumentReference ref =
      Firestore.instance.collection("organizations").document(userID);

  await ref.setData({
    "address": address,
    "description": description,
    "email": email,
    "name": name,
    "phone number": phoneNumber,
    "photo": photoLink
  });
  print("Organization profile submitted");
}

Future<bool> existsInDatabase() async {
  FirebaseUser user = await getCurrentUser();
  final String uid = user.uid;

  DocumentReference refInd =
      Firestore.instance.collection('individuals').document(uid);
  DocumentSnapshot docInd = await refInd.get();

  DocumentReference refOrg =
      Firestore.instance.collection('organizations').document(uid);
  DocumentSnapshot docOrg = await refOrg.get();

  bool both = docOrg.exists && docInd.exists;

  print('$uid is found: $both');

  return docOrg.exists && docInd.exists;
}
