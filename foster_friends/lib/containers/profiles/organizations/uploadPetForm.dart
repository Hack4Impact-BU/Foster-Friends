import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foster_friends/state/appState.dart';


class UploadPetForm extends StatefulWidget {
  @override
  UploadPetFormState createState() {
    return UploadPetFormState();
  }
}

class UploadPetFormState extends State<UploadPetForm> {
  List<String> _organizations = [];
  
  @override
  void initState() {
    
    super.initState();
    Firestore.instance.collection('organizations').snapshots().listen((snapshot) {
      snapshot.documents.forEach((doc){
        this._organizations.add(doc.data['name']);
        setState(() {
          
        });
      });
    });
  }

  // -------------------------- map location function -----------------------
  String _locationMessageCoordinate = "Get Coordinate *";
  String _locationMessageAddress = "Get Org Address *";
  Geoflutterfire geo = Geoflutterfire();
  String petLocation1 = "";
  String petLocation2 = "";
  var myLocation;
  bool getloc = false;

  void _getCurrentLocation() async {
    // Geoflutterfire geo = Geoflutterfire();

      final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _locationMessageCoordinate = "Coordinate Get!";
        petLocation1 = "${position.latitude},${position.longitude}";
      });
    
  }
  void _getCurrentLocation2() async {
    String temp = store.state.userData["address"];
    setState(() {
      //var temp = Firestore.instance.collection("organizations").snapshots();
      //_locationMessageAddress = temp.data.documents[user.uid]['address'];
      _locationMessageAddress = "Org Address Get!";
      petLocation2 = temp;
    });
  }
  // -------------------------- save user inputs ----------------------------
  final petAge = TextEditingController();
  List<String> petBreed = <String>[];
  final petDescription = TextEditingController();
  final petName = TextEditingController();
  final petSex = TextEditingController();
  final petActivityLevel = TextEditingController();
  final petType = TextEditingController();
  final otherBreed = TextEditingController();
  final petOrganization = TextEditingController();
  var petImage;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    petAge.dispose();
    petBreed.removeRange(0,petBreed.length);
    petDescription.dispose();
    petName.dispose();
    petSex.dispose();
    petActivityLevel.dispose();
    petType.dispose();
    petOrganization.dispose();
    otherBreed.dispose();
    //petImage = "";
    _selectedPetTypes = "";
    _selectedBreedTypes = null;
    super.dispose();
  }


  // -------------------------- variables for pet type, breed, sex dropdown menu ----------------------------
  //static Map<String, List<String>> map = {'Dog':['Labrador Retrievers', 'German Shepherd Dogs', 'Golden Retrievers'],'Cat':['Maine Coon','Bengal','Siamese'],'Bird':['Maine Coon','Bengal','Siamese']};
  List<String> _petTypes = ['Dog', 'Cat', 'Others'];
  List<String> _dogBreed = ['Labrador Retrievers', 'Golden Retrievers','Others'];
  List<String> _catBreed = ['Maine Coon','Bengal','Siamese','Others'];
  static List<String> _breedType = [];
  final List<String> selectedBreedType = <String>[];
  String _selectedPetTypes;
  String _selectedBreedTypes;
  //String otherBreedStr;
  String _selectedSex;
  String _selectedActivityLevel;
  List<String> _sex = ['Female','Male'];
  List<String> _activity = ['High','Medium','Low'];

  // -------------------------- upload photo -------------------------------
  File _image;
   getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      petImage = image;
      setState(() {
        _image = image;
      });
    }

    Future uploadPic(BuildContext context) async{
       String fileName = basename(_image.path);
       petImage = fileName;
       StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
       StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
       StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
       setState(() {
          print("Profile Picture uploaded");
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
       });
    }

  // -------------------------- enable / disable SUBMIT button ----------------------------
  bool _enabled = false;

  Color color = const Color(0xFFFFCC80);

  var maxWidthChild = SizedBox(
            width: 130,
            child: Text("View Entered Breed",
              maxLines: 1,
              overflow: TextOverflow.ellipsis));


  @override
  Widget build(BuildContext context) {
    void showSelectedBreed () {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Breed:'),
            content: Container(
              color: Colors.grey[200],
              child: Wrap(
                spacing: 10.0,
                children: selectedBreedType.map((item) {
                  return Chip(
                    backgroundColor: Colors.yellow,
                    label: Text(item),
                  );
                }).toList(),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text("Thank you for submitting a pet!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Continue"),
              onPressed: () {
                //Navigator.popUntil(context, ModalRoute.withName("/Landing"));
                //Navigator.popAndPushNamed(context, "/Landing");
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
    var _onPressed;
    if (petName.text!= "" && petAge.text!="" && petOrganization!="" && petType.text!=""  && selectedBreedType.isNotEmpty && petSex.text!="" && petActivityLevel.text!="" && petDescription.text!="" && petLocation1!="" && petLocation2!="" && petImage!=null) {
      _onPressed = () async {
        DocumentReference ref = Firestore.instance.collection("pets").document();
        String petId = ref.documentID;
        uploadPic(context);
        var pos = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        GeoFirePoint myLocation = geo.point(latitude: pos.latitude, longitude: pos.longitude);

        
        await ref.setData({
                "id": petId,
                "age": int.parse(petAge.text),
                "breed": petBreed,
                "description": petDescription.text,
                //"geopoint": new GeoPoint(double.parse(petLocation1.split(",")[0]),double.parse(petLocation1.split(",")[1])),
                "point": myLocation.data,
                "orgAddress": store.state.userData["address"],
                "name": petName.text,
                "sex": petSex.text,
                "activityLevel": petActivityLevel.text,
                "type": petType.text,
                "organization": store.state.userData["name"],
                "image": petImage,
              });
        print("haro");
        _showDialog();
      };
    }
    
    void _showDialogAdd(addnew) {
    // flutter defined function
      if (petType.text!="" && addnew!="") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: new Text("New breed added: "+addnew),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("Confirm"),
                  onPressed: () {
                    selectedBreedType.add(addnew);
                    otherBreed.text = "";
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        );
      }
      else if (petType.text=="") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: new Text("Please select a pet type first"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Back"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        );
      }
      else if (addnew == "") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: new Text("Please enter a breed type"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Back"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        );
      }
    }

    return Column(children: <Widget>[
      
      TextFormField(
          decoration: const InputDecoration(
            hintText: 'Pet Name *',
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
            hintText: 'Pet Age *',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a pet age';
            }
            return null;
          },
          controller: petAge,
          ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
        
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Text('Organization: ' + store.state.userData["name"],
                          style: TextStyle(
                              fontSize: 16.0,
                              letterSpacing: 1.5),
                          textAlign: TextAlign.left)
          )]
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: DropdownButton(
              hint: Text('Select a Pet Type *'), // Not necessary for Option 1
              value: _selectedPetTypes,
              onChanged: (newValue) {
                _selectedBreedTypes = null;
                selectedBreedType.removeRange(0, selectedBreedType.length);
                setState(() {
                  petType.text = newValue;
                  if (newValue == _selectedPetTypes) {
                    _selectedPetTypes = null;
                    _breedType = [];
                  }
                  else if (newValue == "Dog") {
                    _selectedPetTypes = newValue;
                    _breedType = _dogBreed;
                  } else if (newValue == "Cat") {
                    _selectedPetTypes = newValue;
                    _breedType = _catBreed;
                  }
                  else {
                    petType.text="";
                    _selectedPetTypes = newValue;
                    _breedType = [];
                  }
                });
              },
              items: _petTypes.map((location) {
                return DropdownMenuItem(
                  child: new Text(location),
                  value: location,
                );
              }).toList(),
            )),
          Expanded(
            child: Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'If "Others", please specify',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return '';
                }
                else {
                  if (petType.text == "Others") {
                    petType.text = value;
                    controller: petType;
                  }
                }
                return null;
              },
              
            ))),
        ]
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget> [
          Padding (
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: DropdownButton(
              hint: Text('Select Breed Type(s) *'), // Not necessary for Option 1
              value: selectedBreedType.isEmpty ? null:selectedBreedType.last,
              onChanged: (String newValue) {
                setState(() {
                  if (selectedBreedType.contains(newValue)) {
                    selectedBreedType.remove(newValue);
                  } else {
                    selectedBreedType.add(newValue);
                  }
                  petBreed = selectedBreedType;
                });
              },
              items: _breedType.map((location) {
                return DropdownMenuItem <String>(
                  value: location,
                  child: Row(          
                    children: <Widget> [
                      Icon (
                        Icons.check,
                        color: selectedBreedType.contains(location) ? Colors.black:Colors.transparent,
                      ),
                      Text(location)
                      ]
                  ),
                );
              }).toList(),
            ),
          ),
          Padding (
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: FlatButton(
              color: color,
              child: maxWidthChild,
              onPressed: () {
                showSelectedBreed();
              }
            )
          )
        ]
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget> [
          Expanded(
            child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Other breed types',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return '';
                }
                else {
                  otherBreed.text = value;
                  controller: otherBreed;
                }
                return null;
              },
              controller: otherBreed,
            ))),
          Padding (
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: RaisedButton(
              color: color,
              child: Text("Add"),
              //onPressed: _showAdd,
              onPressed: () {
                  String add = otherBreed.text;
                  _showDialogAdd(add);
                  otherBreed.text = "";
              }
            )
          )
        ]
      ),
          
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget> [
          DropdownButton(
          hint: Text('Select a Sex *'), // Not necessary for Option 1
          value: _selectedSex,
          onChanged: (newValue) {
            setState(() {
              petSex.text = newValue;
              _selectedSex = newValue;
            });
          },
          items: _sex.map((location) {
            return DropdownMenuItem(
              child: new Text(location),
              value: location,
            );
          }).toList(),
      )]),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget> [
          DropdownButton(
          hint: Text('Select an Activity Level *'),
          value: _selectedActivityLevel,
          onChanged: (newValue) {
            setState(() {
              petActivityLevel.text = newValue;
              _selectedActivityLevel = newValue;
            });
          },
          items: _activity.map((location) {
            return DropdownMenuItem(
              child: new Text(location),
              value: location,
            );
          }).toList(),
        )]),
      TextFormField(
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        maxLines: null,
        decoration: const InputDecoration(
            hintText: 'Pet Description *',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a pet description';
            }
            return null;
          },
          controller: petDescription,
          ),
      Row (
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: FlatButton(
              color: color,
              child: Text(_locationMessageCoordinate),
              onPressed: () {
                _getCurrentLocation();
              }),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: FlatButton(
              color: color,
              child: Text(_locationMessageAddress),
              onPressed: () {
                _getCurrentLocation2();
              }
            ),
          )
        ]
      ),
      SizedBox(height: 10,),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xff476cfb),
                      child: ClipOval(
                        child: new SizedBox(
                          width: 100.0,
                          height: 100.0,
                          child: (_image!=null)?Image.file(
                            _image,
                            fit: BoxFit.fill,
                          ):Image.network(
                            "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40.0),
                    child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.camera,
                        size: 30.0,
                      ),
                      onPressed: () {
                        getImage();
                      },
                    ),
                  ),
                ],
      )]),
        Row (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 30, 30, 0),
            child: Center(
              child: RaisedButton(
                color: Theme.of(context).buttonColor,
                onPressed: _onPressed,
                child: Text("SUBMIT",
                style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).backgroundColor)),
              ))),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
            child: Center(
              child: RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                textColor: Colors.white,
                
                child: Text("CANCEL",
                  style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          )),
                
              )))]),
              
    ]);
    
  }
}