import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foster_friends/containers/authentication/authentication.dart';

final Firestore firestore = Firestore.instance;

  CollectionReference get indivs => firestore.collection('individuals');
  CollectionReference get orgs => firestore.collection('organizations');


// Based on template, not actually functional
Future<void> writeUser(String email, String name, String location) async {
  firestore.runTransaction((Transaction transaction) async {
      final allDocs = await indivs.getDocuments();
      final toBeRetrieved =
          allDocs.documents.sublist(allDocs.documents.length ~/ 2);
      final toBeDeleted =
          allDocs.documents.sublist(0, allDocs.documents.length ~/ 2);
      await Future.forEach(toBeDeleted, (DocumentSnapshot snapshot) async {
        await transaction.delete(snapshot.reference);
      });

      await Future.forEach(toBeRetrieved, (DocumentSnapshot snapshot) async {
        await transaction.update(snapshot.reference, {
          "message": "Updated from Transaction",
          "created_at": FieldValue.serverTimestamp()
        });
      });
    });

    await Future.forEach(List.generate(2, (index) => index), (item) async {
      await firestore.runTransaction((Transaction transaction) async {
        await Future.forEach(List.generate(10, (index) => index), (item) async {
          await transaction.set(indivs.document(), {
            "message": "Created from Transaction $item",
            "created_at": FieldValue.serverTimestamp()
          });
        });
      });
    });
}

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


  return (await checkIndividuals(uid)) || ( await checkOrganization(uid));
}

Future<bool> checkIndividuals(String uid) async {
  DocumentReference ref =  Firestore.instance.collection('individuals').document(uid);
  DocumentSnapshot docInd = await ref.get();
  return docInd.exists;
}

Future<bool> checkOrganization(String uid) async{
  DocumentReference refOrg =
      Firestore.instance.collection('organizations').document(uid);
  DocumentSnapshot docOrg = await refOrg.get();
  return docOrg.exists;
}



Future<String> getUserType(String uid) async {
    if (uid == '') {
      return "";
    }
    else if(await checkOrganization(uid)){
      return "Organization";
    }
    else if(await checkIndividuals(uid)){
      return "Individual";
    }
}