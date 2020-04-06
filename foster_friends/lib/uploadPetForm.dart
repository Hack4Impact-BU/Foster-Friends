import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadPetForm extends StatefulWidget {
  @override
  UploadPetFormState createState() {
    return UploadPetFormState();
  }
}

class UploadPetFormState extends State<UploadPetForm> {
  // -------------------------- save user inputs ----------------------------
  final petAge = TextEditingController();
  final petBreed = TextEditingController();
  final petDescription = TextEditingController();
  final petLocation = TextEditingController();
  final petName = TextEditingController();
  final petSex = TextEditingController();
  final petType = TextEditingController();
  final petOrganization = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    petName.dispose();
    petBreed.dispose();
    petDescription.dispose();
    petLocation.dispose();
    petName.dispose();
    petSex.dispose();
    petType.dispose();
    petOrganization.dispose();
    super.dispose();
  }


  // -------------------------- variables for dropdown menu ----------------------------
  //static Map<String, List<String>> map = {'Dog':['Labrador Retrievers', 'German Shepherd Dogs', 'Golden Retrievers'],'Cat':['Maine Coon','Bengal','Siamese'],'Bird':['Maine Coon','Bengal','Siamese']};
  List<String> _petTypes = ['Dog', 'Cat', 'Bird'];
  List<String> _dogBreed = ['Labrador Retrievers', 'German Shepherd Dogs', 'Golden Retrievers'];
  List<String> _catBreed = ['Maine Coon','Bengal','Siamese'];
  List<String> _birdBreed = [''];
  static List<String> _breedType = [];
  String _selectedPetTypes;
  String _selectedBreedTypes;
  @override
  Widget build(BuildContext context) {
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
                          "location": petLocation.text,
                          "name": petName.text,
                          "sex": petSex.text,
                          "type": petType.text,
                          "organization": petOrganization.text,
                        });
                  print("ho");
                  // Validate returns true if the form is valid, otherwise false.
                },
                child: Text("Submit",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).backgroundColor)),
              )))
    ])
    ;
    
  }
}
