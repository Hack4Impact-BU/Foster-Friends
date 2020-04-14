import 'package:cloud_firestore/cloud_firestore.dart';

void pushIndividualProfile(String userID, String phoneNumber, String email, String location, String name )  async {
        DocumentReference ref = Firestore.instance.collection("individuals").document(userID);
   
        await ref.setData({
                "email": email,
                "phone number": phoneNumber,
                "location": location,
                "name": name
              });
        print("User profile submitted");
}

void pushOrganizationProfile(String userID, String address, String description, 
      String email, String name, String phoneNumber, String photoLink) async{
                DocumentReference ref = Firestore.instance.collection("individuals").document(userID);
   
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