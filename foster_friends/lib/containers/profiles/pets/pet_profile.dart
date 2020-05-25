import 'package:flutter/material.dart';
import 'package:foster_friends/containers/profiles/pets/edit_pet_profile.dart';
import 'package:foster_friends/state/appState.dart';
import 'package:foster_friends/database.dart';

// Define a custom Form widget.
class PetProfile extends StatefulWidget {
  final data;

  PetProfile(this.data);

  @override
  PetState createState() {
    return PetState(this.data);
  }
}

class PetState extends State<PetProfile> {
  Map<String, dynamic> data;
  PetState(this.data);

  List<bool> _isSelected = [false];

  TextStyle labelStyle = TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold,
      fontFamily: 'roboto',
      fontSize: 15.0,
      letterSpacing: 1.5);

  TextStyle dataStyle = TextStyle(
      color: Colors.black,
      fontFamily: 'roboto',
      fontSize: 15.0,
      letterSpacing: 1.5);

  @override
  void initState() {
    String petID = data['id'];

    if (store.state.userData != null) {
      List<Map<String, dynamic>> favPets = store.state.userData['pets'];

      for (Map pet in favPets) {
        if (pet['id'] == petID) {
          _isSelected[0] = true;
        }
      }
    }
    print("initial is $_isSelected");
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    if (store.state.user != null) {
      await toggleFavPet(data['id'], _isSelected[0]).then((value) => store
          .dispatch(getFirebaseUser)
          .then((value) =>
              store.dispatch(new UpdateQueryAction(store.state.query))));
    }

    
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        // color: Colors.white,
        child: ListView(shrinkWrap: true, children: <Widget>[
      _header(),
      _summary(),
      Divider(color: Colors.grey),
      _details()
    ]));
  }

  Widget _header() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BackButton(
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
          _showFavorite()
        ],
      ),
    );
  }

  Widget _summary() {
    return Column(
      children: <Widget>[
        Image.network(data['image'],
            height: 200, width: 400, fit: BoxFit.cover),
        Container(
          padding: EdgeInsets.only(top: 30),
          alignment: Alignment.center,
          child: Text(data['name'],
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'roboto',
                  fontSize: 40.0,
                  letterSpacing: 1.5)),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          alignment: Alignment.center,
          child: Text(
            data['description'],
            style: dataStyle,
          ),
        ),
        Visibility(
          visible: _isCorrectOrganization(),
          child: FlatButton(
              child: Text('Edit Pet Profile'),
              color: Colors.black12,
              onPressed: () {
                Navigator.pop(context);
                showDialog(context: context, builder: (BuildContext context) => EditPetProfile(data));
              }),
        ),
      ],
    );
  }

  bool _isCorrectOrganization() {
    if (store.state.user != null) if (data['organization'] ==
        store.state.userData['name']) return true;
    return false;
  }

  Widget _details() {
    return Column(children: <Widget>[
      Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Pet Type", style: labelStyle),
            Text(data['type'], style: dataStyle)
          ]),
      SizedBox(height: 20),
      Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "Breed",
              style: labelStyle,
            ),
            Text(data['breed'].toString(), style: dataStyle)
          ]),
      SizedBox(height: 20),
      Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Organization", style: labelStyle),
            Text(data['organization'], style: dataStyle)
          ]),
      SizedBox(height: 20),
      Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Activity Level", style: labelStyle),
            Text(data['activityLevel'], style: dataStyle)
          ]),
      SizedBox(height: 20),
      Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Gender", style: labelStyle),
            Text(data['sex'], style: dataStyle)
          ]),
      SizedBox(height: 20),
      Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Age", style: labelStyle),
            Text(data['age'].toString(), style: dataStyle)
          ]),
      SizedBox(height: 20),
      Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Organization Address", style: labelStyle),
            Text(data['orgAddress'], style: dataStyle)
          ]),
    ]);
  }

  Widget _showFavorite() {
    if (store.state.user == null || ( store.state.user != null && store.state.userData['type'] != 'organization')) {
      return ToggleButtons(
        children: [Icon(Icons.favorite)],
        isSelected: _isSelected,
        selectedColor: Colors.red,
        color: Colors.black26,
        fillColor: Colors.white,
        borderColor: Colors.white,
        selectedBorderColor: Colors.white,
        splashColor: Colors.white,
        onPressed: (int index) {
          if (store.state.user == null) {
            showDialog(
                context: context,
                builder: (BuildContext context) => _notSignedIn());
          } else {
            setState(() {
              _isSelected[index] = !_isSelected[index];
            });
          }
        },
      );
    } else {
      return Container(height: 0, width: 0);
    }
  }

  Widget _notSignedIn() {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Please log in to add " + data['name'] + " to your pets",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 30,
                ),
              )),
          RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w800))),
        ],
      ),
    );
  }
}
