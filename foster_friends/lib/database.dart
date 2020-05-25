import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foster_friends/containers/authentication/authentication.dart';
import 'package:foster_friends/containers/profiles/image.dart';
import 'package:foster_friends/state/appState.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';

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

Future<void> pushProfile(
    String userID,
    String phoneNumber,
    String email,
    String location,
    String name,
    String address,
    String description,
    String photoLink,
    bool isIndividual) async {
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
    "type": "individual",
    "pets": [],
    "photo": ""
  }).then((value) => store.dispatch(getFirebaseUser));
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
    "type": "organization",
    "pets": []
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

Future<bool> existsFav(checkPet) async {
  FirebaseUser user = await getCurrentUser();
  final String uid = user.uid;
  DocumentReference ref = firestore.collection('users').document(uid);
  DocumentSnapshot doc = await ref.get();

  for(var pet in doc.data['fav pets']) {
    if (pet == checkPet)
     return true;
  }
  return false;
}

Future<Map<String, dynamic>> getUserData(String uid) async {
  final ref = Firestore.instance; // instantiate database
  DocumentSnapshot s = await ref.collection("users").document(uid).get();

  CollectionReference pets = ref.collection("pets");
  List<Map<String, dynamic>> petInfo = [];
  for (var petID in s.data['pets']) {
    final pet = await pets.document(petID).get();
    Map<String,dynamic> petMap = Map.from(pet.data);
    petMap['image'] = await getNetworkUrl(petMap['image']);
    petInfo.add(petMap);
  }

  print("Pet info is $petInfo");

  return {
    'name': s.data['name'],
    'phone number': s.data['phone number'],
    'email': s.data['email'],
    'address': s.data['address'],
    'photo': await getNetworkUrl(s.data['photo']),
    'pets': petInfo,
    'type': s.data['type'],
    'description': s.data['description']
  };
}

Future<List<Map<String, dynamic>>> databaseQuery(
    Map<String, dynamic> params) async {
  /* 
    Queries based on given age range, type, breed, sex, and activity level.
    Then determines which are at proper distance
  */
  Query query = firestore.collection('pets');
  for (String elem in params.keys) {
    if (params[elem] != null && elem != 'distance') {
      print("Searching for $elem " +
          params[elem].runtimeType.toString() +
          " " +
          params[elem].toString());
      if (elem == 'minAge') {
        query = query.where('age', isGreaterThanOrEqualTo: params[elem]);
      } else if (elem == 'maxAge') {
        query = query.where('age', isLessThanOrEqualTo: params[elem]);
      } else {
        query = query.where(elem, isEqualTo: params[elem]);
      }
    }
  }
  return filterByLocation(
      await query.getDocuments(), params['distance'], params.isNotEmpty);
}

Future<List<Map<String, dynamic>>> filterByLocation(
    QuerySnapshot result, double radius, bool isNotEmpty) async {
  /*
    Find distance between current location and pet location.
    Checks if within radius.
  */
  List<Map<String, dynamic>> petInfo = [];

  Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  for (var snapshot in result.documents) {
    Map<String, dynamic> pet = Map.from(snapshot.data);
    Map petLocation = pet['point'];
    pet['image'] = await getNetworkUrl(pet['image']);
    
    if (isNotEmpty && petLocation != null && radius != null) {
      GeoFirePoint p = GeoFirePoint(
          petLocation['geopoint'].latitude, petLocation['geopoint'].longitude);
      double distance =
          p.distance(lat: position.latitude, lng: position.longitude);
      // print("distance between $p and $position is $distance");
      if (distance <= radius) {
        petInfo.add(pet);
      }
    } else {
      petInfo.add(pet);
    }
  }

  return petInfo;
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

void deletePet (String petID) async {

    FirebaseUser user = await getCurrentUser();
    final String uid = user.uid;
    var pets;
    DocumentReference ref1 = Firestore.instance.collection("pets").document(petID);
    DocumentReference ref2 = Firestore.instance.collection("users").document(uid);

    await ref2.get()
        .then((DocumentSnapshot snapshot)  {
        pets = snapshot.data['pets'];
        });

    pets.removeWhere((item) => item == petID);

    await ref1.delete();
    await ref2.updateData({
      "pets" : pets

    });
    store.dispatch(getFirebaseUser);
  }


  Future <void> toggleFavPet (String petID, bool toggleInfo) async {

    FirebaseUser user = await getCurrentUser();
    final String uid = user.uid;
    var favPets;
    DocumentReference ref = Firestore.instance.collection("users").document(uid);

    await ref.get()
        .then((DocumentSnapshot snapshot)  {
        favPets = snapshot.data['pets'];
        });

    if (toggleInfo == false)
      favPets.removeWhere((item) => item == petID);
    else
      {
        int temp = favPets.indexWhere((pet) => pet ==petID);
        if (temp == -1)
          favPets.add(petID);
          
          
      }

    await ref.updateData({
      "pets" : favPets

    });
  }
    
  
