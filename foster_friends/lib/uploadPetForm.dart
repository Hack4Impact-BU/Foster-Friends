import 'package:flutter/material.dart';

class UploadPetForm extends StatefulWidget {
  @override
  UploadPetFormState createState() {
    return UploadPetFormState();
  }
}

class UploadPetFormState extends State<UploadPetForm> {
  //static Map<String, List<String>> map = {'Dog':['Labrador Retrievers', 'German Shepherd Dogs', 'Golden Retrievers'],'Cat':['Maine Coon','Bengal','Siamese'],'Bird':['Maine Coon','Bengal','Siamese']};
  List<String> _petTypes = ['Dog', 'Cat', 'Bird'];
  List<String> _dogBreed = ['Labrador Retrievers', 'German Shepherd Dogs', 'Golden Retrievers'];
  List<String> _catBreed = ['Maine Coon','Bengal','Siamese'];
  List<String> _birdBreed = [''];
  static List<String> _breedType = [];
  String _selectedPetTypes;
  String _selectedBreedTypes;
  final _formKey = GlobalKey<FormState>();
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
          }),
      DropdownButton(
            hint: Text('Select a Pet Type'), // Not necessary for Option 1
            value: _selectedPetTypes,
            onChanged: (newValue) {
              setState(() {
                _selectedPetTypes = newValue;
                //if (newValue.equals('Dog')) {
                //  _breedType = _dogBreed;
                //} else if (newValue.equals('Cat')) {
                //  _breedType = _catBreed;
                //} else if (newValue.equals('Bird')) {
                //  _breedType = _birdBreed;
                //}
                _breedType = _dogBreed;
                //print((_breedType));
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
            //print(_catBreed);
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
          }),
    ])
    ;
    
  }
}
