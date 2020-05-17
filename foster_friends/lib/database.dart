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

void pushProfile(
    String userID,
    String phoneNumber,
    String email,
    String location,
    String name,
    String address,
    String description,
    String photoLink,
    bool isIndividual) {
  if (isIndividual) {
    pushIndividualProfile(
        userID, phoneNumber, email, location, name, photoLink);
  } else {
    pushOrganizationProfile(
        userID, address, description, email, name, phoneNumber, photoLink);
  }
}

void pushIndividualProfile(String userID, String phoneNumber, String email,
    String location, String name, String photoLink) async {
  DocumentReference ref = firestore.collection("users").document(userID);

  await ref.setData({
    "email": email,
    "phone number": phoneNumber,
    "location": location,
    "name": name,
    "type": "individual"
  });
  print("User profile submitted");
}

void pushOrganizationProfile(String userID, String address, String description,
    String email, String name, String phoneNumber, String photoLink) async {
  DocumentReference ref = firestore.collection("users").document(userID);

  await ref.setData({
    "address": address,
    "description": description,
    "email": email,
    "name": name,
    "phone number": phoneNumber,
    "photo": photoLink,
    "type": "organization"
  });
  print("Organization profile submitted");
}

Future<bool> existsInDatabase() async {
  FirebaseUser user = await getCurrentUser();
  final String uid = user.uid;
  DocumentReference ref = firestore.collection('users').document(uid);
  DocumentSnapshot doc = await ref.get();
  return doc.exists;
}

Future<Map<String, dynamic>> getUserData(String uid) async {
  final ref = Firestore.instance; // instantiate database
  DocumentSnapshot s = await ref.collection("users").document(uid).get();

  return {
    'name': s.data['name'],
    'phone number': s.data['phone number'],
    'email': s.data['email'],
    'address': s.data['address'],
    'photo': s.data['photo'],
    'description': s.data['description'],
    'pets': s.data['pets'],
    'type': s.data['type']
  };
}

Future<Map<String, dynamic>> getPetData(String petID) async {
  final ref = Firestore.instance; 
  DocumentSnapshot s = await ref.collection("pets").document(petID).get();
    
  return {
    'name': s.data['name'],
    'age': s.data['age'],
    'breed': s.data['breed'],
    'activityLevel': s.data['activityLevel'],
    'description': s.data['description'],
    'id': s.data['id'],
    'image': s.data['image'],
    'orgAddress': s.data['orgAddress'],
    'organization': s.data['organization'],
    'sex': s.data['sex'],
    'type': s.data['type'],
  };
}
    
  