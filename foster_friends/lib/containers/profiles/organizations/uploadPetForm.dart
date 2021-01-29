import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foster_friends/state/appState.dart';

Firestore ref = Firestore.instance;

class UploadPetForm extends StatefulWidget {
  @override
  UploadPetFormState createState() {
    return UploadPetFormState();
  }
}

class UploadPetFormState extends State<UploadPetForm> {
  //List<String> _organizations = [];

  @override
  void initState() {
    super.initState();
    // ref.collection('organizations').snapshots().listen((snapshot) {
    //   snapshot.documents.forEach((doc) {
    //     this._organizations.add(doc.data['name']);
    //   });
    // });
  }

  // -------------------------- map location function -----------------------
  String _locationMessageCoordinate = "Get Coordinate *";
  String _locationMessageAddress = "Get Org Address *";
  // Geoflutterfire geo = Geoflutterfire();
  double petLocation1;
  double petLocation2;
  String petLocation3;
  // var myLocation;
  // bool getloc = false;

  void _getCurrentLocation() async {
    // Geoflutterfire geo = Geoflutterfire();

    var pos = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      petLocation1 = pos.latitude;
      petLocation2 = pos.longitude;
      _locationMessageCoordinate = "Coordinate Get: "+petLocation1.toString() + ", "+petLocation2.toString();
    });
  }

  void _getCurrentLocation2() async {
    String temp = store.state.userData["address"];
    setState(() {
      //var temp = Firestore.instance.collection("organizations").snapshots();
      //_locationMessageAddress = temp.data.documents[user.uid]['address'];
      temp = store.state.userData["address"];
      _locationMessageAddress = "Org Address Get: "+temp;
      petLocation3 = temp;
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

  // -------------------------- variables for pet type, breed, sex dropdown menu ----------------------------
  //static Map<String, List<String>> map = {'Dog':['Labrador Retrievers', 'German Shepherd Dogs', 'Golden Retrievers'],'Cat':['Maine Coon','Bengal','Siamese'],'Bird':['Maine Coon','Bengal','Siamese']};
  List<String> _petTypes = ['Dog', 'Cat', 'Others'];
  List<String> _dogBreed = [
    'Labrador Retriever',
    'Golden Retriever'];
  List<String> _catBreed = ['Maine Coon', 'Bengal', 'Siamese'];
  static List<String> _breedType = [];
  final List<String> selectedBreedType = <String>[];
  String _selectedPetTypes;
  String _selectedBreedTypes;
  //String otherBreedStr;
  String _selectedSex;
  String _selectedActivityLevel;
  List<String> _sex = ['Female', 'Male'];
  List<String> _activity = ['High', 'Medium', 'Low'];

  // -------------------------- upload photo -------------------------------
  File _image;
  getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    petImage = image;
    setState(() {
      _image = image;
    });
  }

  Future uploadPic(BuildContext context) async {
    String fileName = basename(_image.path);
    petImage = fileName;
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(petImage);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    print(petImage);
    await uploadTask.onComplete;
    setState(() {
      // print("Profile Picture uploaded");
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });
  }

  // -------------------------- multiple photo -------------------------
  // List<Asset> images = List<Asset>();
  // String _error;
  // Future<void> loadAssets() async {
  //   setState(() {
  //     images = List<Asset>();
  //   });

  //   List<Asset> resultList;
  //   String error;

  //   try {
  //     resultList = await MultiImagePicker.pickImages(
  //       maxImages: 300,
  //     );
  //   } on Exception catch (e) {
  //     error = e.toString();
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;

  //   setState(() {
  //     images = resultList;
  //     if (error == null) _error = 'No Error Dectected';
  //   });
  // }

  // -------------------------- enable / disable SUBMIT button ----------------------------
  // bool _enabled = false;

  Color color = const Color(0xFFFFCC80);

  var maxWidthChild = SizedBox(
      //width: 100,
      child: Text("View Breed",
          maxLines: 1, overflow: TextOverflow.ellipsis));


  @override
  Widget build(BuildContext context) {
    void showSelectedBreed() {
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
                  return RawChip(
                    backgroundColor: Colors.yellow,
                    label: Text(item),
                    onPressed: () {
                      if (_breedType.contains(item)) {
                        showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: new Text("Please remove from the drop down menu"),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("Ok"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                      }
                      else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: new Text("Remove breed? (please refresh after removing)"),
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
                                    selectedBreedType.remove(item);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                      }
                    },
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
    if (petName.text != "" &&
        petAge.text != "" &&
        // petOrganization != "" &&
        petType.text != "" &&
        selectedBreedType.isNotEmpty &&
        petSex.text != "" &&
        petActivityLevel.text != "" &&
        petDescription.text != "" &&
        petLocation1 != null &&
        petLocation2 != null &&
        petImage != null) {
      _onPressed = () async {
        DocumentReference petRef = ref.collection("pets").document();
        String petId = petRef.documentID;
        uploadPic(context);

        petRef.setData({
          "id": petId,
          "orgId": store.state.user.uid,
          "age": int.parse(petAge.text),
          "breed": petBreed,
          "description": petDescription.text,
          "latitude": petLocation1,
          "lognitude": petLocation2,
          "orgAddress": petLocation3,
          "name": petName.text,
          "sex": petSex.text,
          "activityLevel": petActivityLevel.text,
          "type": petType.text,
          "organization": store.state.userData["name"],
          "image": petImage,
        }).then((value) {
          ref.collection('users').document(store.state.user.uid).updateData({
            "pets": FieldValue.arrayUnion([petId])
          }).then((value) => store.dispatch(getFirebaseUser));
        });

        // print("haro");
        _showDialog();
      };
    }

    void _showDialogAdd(addnew) {
      // flutter defined function
      if (petType.text != "" && addnew != "") {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: new Text("New breed added: " + addnew),
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
            });
      } else if (petType.text == "") {
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
            });
      } else if (addnew == "") {
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
            });
      }
    }

    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.center,
     children: <Widget>[
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
      Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
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
                  } else if (newValue == "Dog") {
                    _selectedPetTypes = newValue;
                    _breedType = _dogBreed;
                  } else if (newValue == "Cat") {
                    _selectedPetTypes = newValue;
                    _breedType = _catBreed;
                  } else {
                    petType.text = "";
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
                    } else {
                      if (petType.text == "Others") {
                        petType.text = value;
                        controller: petType;
                      }
                    }
                    return null;
                  },
                ))),
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: DropdownButton(
            hint: Text('Select Breed Type(s) *'), // Not necessary for Option 1
            value: selectedBreedType.isEmpty ? null : selectedBreedType.last,
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
              return DropdownMenuItem<String>(
                value: location,
                child: Row(children: <Widget>[
                  Icon(
                    Icons.check,
                    color: selectedBreedType.contains(location)
                        ? Colors.black
                        : Colors.transparent,
                  ),
                  Text(location)
                ]),
              );
            }).toList(),
          ),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: FlatButton(
                color: color,
                child: maxWidthChild,
                onPressed: () {
                  showSelectedBreed();
                }))
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
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
                    } else {
                      otherBreed.text = value;
                    }
                    return null;
                  },
                  controller: otherBreed,
                ))),
        Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: RaisedButton(
                color: color,
                child: Text("Add"),
                //onPressed: _showAdd,
                onPressed: () {
                  String add = otherBreed.text;
                  _showDialogAdd(add);
                  otherBreed.text = "";
                }))
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
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
        )
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
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
        )
      ]),
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
            }),
      ),
      SizedBox(
        height: 10,
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
                    child: (_image != null)
                        ? Image.file(
                            _image,
                            fit: BoxFit.fill,
                          )
                        : Image.network(
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
        )
      ]),
      // SizedBox(
      //   height: 10,
      // ),
      // FlatButton(
      //   color: color,
      //   child: Text("Upload images"),
      //   onPressed: loadAssets
      // ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
            )))
      ]),
    ]);
  }
}