import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foster_friends/containers/profiles/organizations/pet_profile.dart';

final databaseReference = Firestore.instance; // instantiate database
final petsDatabase = databaseReference.collection("petstest");


String name = '';
String description = '';
String email = '';
String ph = '';
String photo = '';
List pets = [];
List<Map<String, dynamic>> petInfo = [];

class Results extends StatefulWidget {
  @override
  _Results createState() => _Results();
}

class _Results extends State<Results> {
  List pets;
  bool _isLoading;

  @override
  void initState(){
    pets = [];
    _isLoading = true;
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildGrid(context);
  }

  Widget _buildGrid(BuildContext context) => GridView.count(
      // shrinkWrap: true,
      crossAxisCount: 3,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.all(4),
      children: _buildGridTileList(pets.length, context));

  List<Widget> _buildGridTileList(int count, BuildContext context) =>
      List.generate(count, (i) {
        return Padding(
          padding: const EdgeInsets.all(1.0),
            child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(petInfo[i]['Photo']), fit: BoxFit.cover),
                ),
                child: FlatButton(
                  child: null,
                  // padding: EdgeInsets.all(0.0),
                  onPressed: () {
                    print("Hello");
                    // showDialog(context: context, builder:(BuildContext context) => PetProfile() );
                    Navigator.pushNamed(context, '/Pet_Profile',
                        arguments: petInfo[i]);
                  },
                )),
        
        );
      });

  getData() async {
    await databaseReference
        .collection("organizations")
        .document("IahwMOjwYdgEKY2cli5f")
        .get()
        .then((DocumentSnapshot snapshot) async {
      name = snapshot.data['name'];
      description = snapshot.data['description'];
      email = snapshot.data['email'];
      ph = snapshot.data['phone number'];
      photo = snapshot.data['photo'];
      pets = snapshot.data['pets'];

      for (var i in pets) {
        var ind = pets.indexOf(i);
        await getPet(i, ind);
      }

      print(pets.length);
      if (this.mounted) {
        setState(() {});
      }
    });
  }

  getPet(String petID, int ind) async {
    await databaseReference
        .collection("petstest")
        .document(petID)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.data != null) {
        petInfo.add(snapshot.data);

        petInfo[ind]['ID'] = petID;
      }
    });
  }
}
