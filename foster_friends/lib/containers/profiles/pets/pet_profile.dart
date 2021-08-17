import 'package:flutter/material.dart';
import 'package:foster_friends/containers/profiles/pets/edit_pet_profile.dart';
import 'package:foster_friends/state/appState.dart';
import 'package:foster_friends/database.dart';

// Define a custom Form widget.
class PetProfile extends StatefulWidget {
  final data;
  final userData;

  PetProfile(this.data, this.userData);

  @override
  PetState createState() {
    return PetState(this.data, this.userData);
  }
}

class PetState extends State<PetProfile> {
  Map<String, dynamic> data;
  Map<String, dynamic> userData;
  Map<String, dynamic> petUser = store.state.userPetData;
  PetState(this.data, this.userData);

  List<bool> _isSelected = [false];

  TextStyle labelStyle = TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontFamily: 'roboto', fontSize: 15.0, letterSpacing: 1.5);

  TextStyle dataStyle = TextStyle(color: Colors.black, fontFamily: 'roboto', fontSize: 15.0, letterSpacing: 1.5);

  @override
  void initState() {
    String petID = data['id'];
    if (store.state.userData.toString() != "{}") {
      final favPets = store.state.userData['pets'];

      for (Map pet in favPets) {
        if (pet['id'] == petID) {
          _isSelected[0] = true;
        }
      }
    }
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    if (store.state.user == null || (store.state.user != null && store.state.userData['type'] != 'organization')) {
      await toggleFavPet(data['id'], _isSelected[0])
          .then((value) => store.dispatch(getFirebaseUser).then((value) => store.dispatch(new UpdateQueryAction(store.state.query))));
    }
  }

  bool _anyAreNull() {
    return petUser['name'] == null || petUser['address'] == null;
  }

  @override
  Widget build(BuildContext context) {
    if (_anyAreNull()) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Card(child: ListView(shrinkWrap: true, children: <Widget>[_header(), _summary(), Divider(color: Colors.grey), _details()]));
    }
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
        Image.network(data['image'], height: 200, width: 400, fit: BoxFit.cover),
        Container(
          padding: EdgeInsets.only(top: 30),
          alignment: Alignment.center,
          child: Text(data['name'], style: TextStyle(color: Colors.black, fontFamily: 'roboto', fontSize: 40.0, letterSpacing: 1.5)),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
              color: Theme.of(context).buttonColor,
              onPressed: () {
                Navigator.pop(context);
                showDialog(context: context, builder: (BuildContext context) => EditPetProfile(data));
              }),
        ),
      ],
    );
  }

  bool _isCorrectOrganization() {
    if (store.state.user != null) {
      if (data['orgId'] == store.state.user.uid) return true;
    }
    return false;
  }

  Widget _details() {
    return Column(children: <Widget>[
      Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[Text("Pet Type", style: labelStyle), Text(data['type'], style: dataStyle)]),
      SizedBox(height: 20),
      Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        Text(
          "Breed",
          style: labelStyle,
        ),
        Text(data['breed'].toString(), style: dataStyle)
      ]),
      SizedBox(height: 20),
      Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[Text("Organization", style: labelStyle), Text(petUser['name'], style: dataStyle)]),
      SizedBox(height: 20),
      Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[Text("Activity Level", style: labelStyle), Text(data['activityLevel'], style: dataStyle)]),
      SizedBox(height: 20),
      Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[Text("Gender", style: labelStyle), Text(data['sex'], style: dataStyle)]),
      SizedBox(height: 20),
      Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[Text("Age", style: labelStyle), Text(data['age'].toString(), style: dataStyle)]),
      SizedBox(height: 20),
      Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[Text("Organization Address", style: labelStyle), Text(petUser['address'], style: dataStyle)]),
    ]);
  }

  Widget _showFavorite() {
    if (store.state.user == null || (store.state.user != null && store.state.userData['type'] != 'organization')) {
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
            showDialog(context: context, builder: (BuildContext context) => _notSignedIn());
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
              child: Text("OK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800))),
        ],
      ),
    );
  }
}
