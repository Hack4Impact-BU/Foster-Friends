import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import './main.dart';

class UploadPetForm extends StatefulWidget {
  @override
  UploadPetFormState createState() {
    return UploadPetFormState();
  }
}

class UploadPetFormState extends State<UploadPetForm> {
  // -------------------------- map location function -----------------------
  String _locationMessage = "Location";
  Geoflutterfire geo = Geoflutterfire();
  String petLocation = "";
  void _getCurrentLocation() async {
    final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _locationMessage = "${position.latitude},${position.longitude}";
      petLocation = "${position.latitude},${position.longitude}";
      print(petLocation);
      //print(_organizations);
    });
  }
  // -------------------------- save user inputs ----------------------------
  final petAge = TextEditingController();
  final petBreed = TextEditingController();
  final petDescription = TextEditingController();
  final petName = TextEditingController();
  final petSex = TextEditingController();
  final petActivityLevel = TextEditingController();
  final petType = TextEditingController();
  final petOrganization = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    petName.dispose();
    petBreed.dispose();
    petDescription.dispose();
    petName.dispose();
    petSex.dispose();
    petActivityLevel.dispose();
    petType.dispose();
    petOrganization.dispose();
    super.dispose();
  }


  // -------------------------- variables for pet type, breed, sex dropdown menu ----------------------------
  //static Map<String, List<String>> map = {'Dog':['Labrador Retrievers', 'German Shepherd Dogs', 'Golden Retrievers'],'Cat':['Maine Coon','Bengal','Siamese'],'Bird':['Maine Coon','Bengal','Siamese']};
  List<String> _petTypes = ['Dog', 'Cat', 'Bird'];
  List<String> _dogBreed = ['Labrador Retrievers', 'German Shepherd Dogs', 'Golden Retrievers'];
  List<String> _catBreed = ['Maine Coon','Bengal','Siamese'];
  List<String> _birdBreed = [''];
  static List<String> _breedType = [];
  String _selectedPetTypes;
  String _selectedBreedTypes;
  String _selectedSex;
  String _selectedActivityLevel;
  List<String> _sex = ['Female','Male'];
  List<String> _activity = ['High','Medium','Low'];

  // -------------------------- variables for shelter name dropdown menu ----------------------------
  //List<String> _shelters = Firestore.instance.collection("organizations").getDocuments() as List<String>;
  //Future<QuerySnapshot> ref = Firestore.instance.collectionGroup("organizations").getDocuments();
  //Firestore.instance.collection('organizations').snapshots().listen((data) => data.documents.forEach((doc) => print(doc["name"])));
  static List<DocumentSnapshot> _organizations;
  String _selectedOrganization;
  //StreamSubscription<QuerySnapshot> getOrganizations = Firestore.instance.collection('organizations')
  //  .snapshots().listen(
  //        (data) => _organizations.add('${data.documents[0]['name']}')
  //  );
  void _getOrganizations() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection("collection").getDocuments();
    var list = querySnapshot.documents;
    setState(() {
      _organizations = list;
    });
  }
  @override
  Widget build(BuildContext context) {
    //print(_shelters);
    return Column(children: <Widget>[
      TextFormField(
          decoration: const InputDecoration(
            hintText: 'Pet Name',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a pet name';
            }
            return null;
          },
          controller: petName,
          ),
      TextFormField(
          decoration: const InputDecoration(
            hintText: 'Pet Age',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a pet age';
            }
            return null;
          },
          controller: petAge,
          ),
      StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("organizations").snapshots(),
        builder: (context,snapshot) {
          if(!snapshot.hasData) {
            Text("Loading");
          }
          else {
            List<DropdownMenuItem> organinzationsItems = [];
            for (int i = 0; i < snapshot.data.documents.length; i++) {
              DocumentSnapshot snap = snapshot.data.documents[i];
              organinzationsItems.add(
                DropdownMenuItem (child: Text(
                  snap.documentID,
                  ),
                value: "${snap.documentID}",
                )
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DropdownButton(
                  hint: Text('Organization'),
                  items: organinzationsItems,
                  onChanged: (organizationsValue){
                    setState(() {
                      _selectedOrganization = organizationsValue;
                      petOrganization.text = organizationsValue;
                    });
                  },
                  value: _selectedOrganization,
                )
              ],
            );
          }
        },
      ),
      DropdownButton(
            hint: Text('Select a Pet Type'), // Not necessary for Option 1
            value: _selectedPetTypes,
            onChanged: (newValue) {
              setState(() {
                petType.text = newValue;
                _selectedPetTypes = newValue;
                if (newValue == "Dog") {
                  _breedType = _dogBreed;
                } else if (newValue == "Cat") {
                  _breedType = _catBreed;
                } else if (newValue == "Bird") {
                  _breedType = _birdBreed;
                }
              });
            },
            items: _petTypes.map((location) {
              return DropdownMenuItem(
                child: new Text(location),
                value: location,
              );
            }).toList(),
          ),
      DropdownButton(
        hint: Text('Select a Breed Type'), // Not necessary for Option 1
        value: _selectedBreedTypes,
        onChanged: (newValue) {
          setState(() {
            petBreed.text = newValue;
            _selectedBreedTypes = newValue;
          });
        },
        // ??????????????????????? if () _breedType
        items: _breedType.map((location) {
          return DropdownMenuItem(
            child: new Text(location),
            value: location,
          );
        }).toList(),
      ),
      DropdownButton(
        hint: Text('Select a Sex'), // Not necessary for Option 1
        value: _selectedSex,
        onChanged: (newValue) {
          setState(() {
            petSex.text = newValue;
            _selectedSex = newValue;
          });
        },
        // ??????????????????????? if () _breedType
        items: _sex.map((location) {
          return DropdownMenuItem(
            child: new Text(location),
            value: location,
          );
        }).toList(),
      ),
      DropdownButton(
        hint: Text('Select an Activity Level'), // Not necessary for Option 1
        value: _selectedActivityLevel,
        onChanged: (newValue) {
          setState(() {
            petActivityLevel.text = newValue;
            _selectedActivityLevel = newValue;
          });
        },
        // ??????????????????????? if () _breedType
        items: _activity.map((location) {
          return DropdownMenuItem(
            child: new Text(location),
            value: location,
          );
        }).toList(),
      ),
      TextFormField(
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
            hintText: 'Pet Description',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a pet description';
            }
            return null;
          },
          controller: petDescription,
          ),
      FlatButton(
        color: Colors.green,
        child: Text(_locationMessage),
        onPressed: () {
          _getCurrentLocation();
      }),

          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Center(
              child: RaisedButton(
                color: Theme.of(context).buttonColor,
                onPressed: () {
                  DocumentReference ref = Firestore.instance.collection("pets").document();
                  String petId = ref.documentID;
                  ref.setData({
                          "id": petId,
                          "age": petAge.text,
                          "breed": petBreed.text,
                          "description": petDescription.text,
                          "location": new GeoPoint(double.parse(petLocation.split(",")[0]),double.parse(petLocation.split(",")[1])),
                          "name": petName.text,
                          "sex": petSex.text,
                          "type": petType.text,
                          "organization": petOrganization.text,
                        });
                  print("ho");
                  Navigator.of(context).pop();
                },
                child: Text("SUBMIT",
                style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).backgroundColor)),
              ))),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Center(
              child: RaisedButton(
                color: Theme.of(context).buttonColor,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("CANCEL",
                style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).backgroundColor)),
              ))),
    ])
    ;
    
  }
}
