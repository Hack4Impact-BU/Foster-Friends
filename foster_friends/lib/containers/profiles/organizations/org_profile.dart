import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './uploadPet.dart';

final databaseReference = Firestore.instance; // instantiate database
final petsDatabase = databaseReference.collection("petstest");

String name = '';
String description = '';
String email = '';
String ph = '';
String photo = '';
List pets = [];
List<Map<String, dynamic>> petInfo = [];


// Define a custom Form widget.
class OrgProfile extends StatefulWidget {
  @override
  OrgState createState() {
    return OrgState();
  }
}

class OrgState extends State<OrgProfile> {
  @override
  void initState() {
    super.initState();
    petInfo = [];
    getData();
  }

  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            body: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(photo),
                      ),
                      Text(name, style: Theme.of(context).textTheme.title),
                      Text(description,
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'roboto',
                              fontSize: 15.0,
                              letterSpacing: 1.5),
                          textAlign: TextAlign.center),
                      RaisedButton(
                        color: Theme.of(context).buttonColor,
                          onPressed: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext context) => new UploadPet()));
                            },
                          
                          child: Text("Upload Pet",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).backgroundColor)),
                                  ),
                      Divider(color: Colors.grey),
                      Container(
                          margin: const EdgeInsets.all(10.0),
                          width: 400.0,
                          height: 393.0,
                          child: _buildGrid(context)),
                    ]))));
  }

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
    return;
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

    return;
  }
}

Widget _buildGrid(BuildContext context) => GridView.count(
    shrinkWrap: true,
    crossAxisCount: 3,
    scrollDirection: Axis.vertical,
    padding: const EdgeInsets.all(4),
    children: _buildGridTileList(pets.length, context));

List<Widget> _buildGridTileList(int count, BuildContext context) =>
    List.generate(count, (i) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(petInfo[i]['Photo']),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              child: FlatButton(
                child: null,
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  Navigator.pushNamed(context, '/Pet_Profile',
                      arguments: petInfo[i]);
                },
              )),
        ),
      );
    });
