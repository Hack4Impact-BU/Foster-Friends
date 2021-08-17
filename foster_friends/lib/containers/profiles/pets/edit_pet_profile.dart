import 'package:flutter/material.dart';
import 'package:foster_friends/state/appState.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foster_friends/database.dart';

// Define a custom Form widget.
class EditPetProfile extends StatefulWidget {
  final data;
  EditPetProfile(this.data);

  @override
  EditPetState createState() {
    return EditPetState(this.data);
  }
}

String name;
List<String> breed;
String image;
String sex;
String type;
String description;
int age;
String petID;
String activityLevel;
List pets = [];

//for current dropdown item
String _selectedPetTypes;
String _selectedSex;
String _selectedActivityLevel;

List<String> _petTypes = ['Dog', 'Cat', 'Others'];
List<String> _sex = ['Female', 'Male'];
List<String> _activity = ['High', 'Medium', 'Low'];
List<String> _breedType = [];
List<String> selectedBreedType;
List<String> _dogBreed = ['Labrador Retriever', 'Golden Retriever'];
List<String> _dogBreedTemp;
List<String> _catBreed = ['Maine Coon', 'Bengal', 'Siamese'];
List<String> _catBreedTemp;
final otherTypeString = TextEditingController();
final otherBreed = TextEditingController();

class EditPetState extends State<EditPetProfile> {
  final petAge = TextEditingController();
  final petDescription = TextEditingController();
  final petName = TextEditingController();

  @override
  void initState() {
    super.initState();
    //setting local variables
    name = data['name'];
    breed = data['breed'].cast<String>();
    sex = data['sex'];
    type = data['type'];
    description = data['description'];
    age = data['age'];
    image = data['image'];
    petID = data['id'];
    activityLevel = data['activityLevel'];
    _selectedSex = sex;
    _selectedPetTypes = type;
    _selectedActivityLevel = activityLevel;
    selectedBreedType = List.from(breed);
    _dogBreedTemp = List.from(_dogBreed);
    _catBreedTemp = List.from(_catBreed);

    //setting initial text field values
    petName.text = name;
    petDescription.text = description;
    petAge.text = age.toString();
    if (type == "Dog") {
      _dogBreedTemp.removeWhere((item) => breed.contains(item));
      _breedType = _dogBreedTemp;
    } else if (type == "Cat") {
      _catBreedTemp.removeWhere((item) => breed.contains(item));
      _breedType = _catBreedTemp;
    }
  }

  Map<String, dynamic> data;
  EditPetState(this.data);

  @override
  void dispose() {
    super.dispose();
  }

// -------------------------- upload photo -------------------------------
  File _image;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Future uploadPic(BuildContext context) async {
    String fileName = basename(_image.path);
    image = fileName;
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    await uploadTask.onComplete;
    setState(() {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });
  }

  @override
  Widget build(BuildContext context) {
    // data = ModalRoute.of(context).settings.arguments;
    Color color = const Color(0xFFFFCC80);
    var maxWidthChild = SizedBox(
        child:
            Text("View Breed", maxLines: 1, overflow: TextOverflow.ellipsis));
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
                                content: new Text(
                                    "Please remove from the drop down menu"),
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
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: new Text(
                                    "Remove breed? (please refresh after removing)"),
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

    void _showDialogAdd(addnew) {
      // flutter defined function
      if ((otherTypeString.text != "" || type != "") && addnew != "") {
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
      } else if (otherTypeString.text == "") {
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

    return Container(
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: ListView(children: <Widget>[
              Container(
                margin: EdgeInsets.all(20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Are you sure?"),
                                        actions: <Widget>[
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              FlatButton(
                                                child: Text('No'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              FlatButton(
                                                child: Text('Yes'),
                                                onPressed: () {
                                                  deletePet(petID);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Text(
                                "Remove Pet Entry",
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          ]),
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
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          image,
                                          fit: BoxFit.cover,
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
                                }),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: petName,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(labelText: 'Age'),
                        controller: petAge,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        "Type",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: DropdownButton<String>(
                                  value: _petTypes.contains(type)
                                      ? type
                                      : "Others",
                                  elevation: 16,
                                  onChanged: (String newValue) {
                                    selectedBreedType.removeRange(
                                        0, selectedBreedType.length);
                                    setState(() {
                                      if (newValue == _selectedPetTypes) {
                                        _selectedPetTypes = newValue;
                                        _breedType = [];
                                      } else if (newValue == "Dog") {
                                        _selectedPetTypes = newValue;
                                        _breedType = _dogBreed;
                                      } else if (newValue == "Cat") {
                                        _selectedPetTypes = newValue;
                                        _breedType = _catBreed;
                                      } else {
                                        type = "";
                                        _selectedPetTypes = newValue;
                                        _breedType = [];
                                      }
                                    });
                                  },
                                  items: _petTypes
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
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
                                      controller: otherTypeString,
                                      validator: (value) {
                                        if (_selectedPetTypes == "Others") {
                                          otherTypeString.text = value;
                                        }
                                        return null;
                                      },
                                    ))),
                          ]),
                      (_breedType != [])
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: DropdownButton(
                                      hint: Text(
                                          'Select Breed Type(s) *'), // Not necessary for Option 1
                                      value: selectedBreedType.isEmpty
                                          ? null
                                          : _breedType.contains(
                                                  selectedBreedType.last)
                                              ? selectedBreedType.last
                                              : null,
                                      onChanged: (String newValue) {
                                        setState(() {
                                          if (selectedBreedType
                                              .contains(newValue)) {
                                            selectedBreedType.remove(newValue);
                                          } else {
                                            selectedBreedType.add(newValue);
                                          }
                                        });
                                      },
                                      items: _breedType.map((location) {
                                        return DropdownMenuItem<String>(
                                          value: location,
                                          child: Row(children: <Widget>[
                                            Icon(
                                              Icons.check,
                                              color: selectedBreedType
                                                      .contains(location)
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
                                ])
                          : SizedBox(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
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
                                    onPressed: () {
                                      String add = otherBreed.text;
                                      _showDialogAdd(add);
                                      otherBreed.text = "";
                                    }))
                          ]),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        "Sex",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                      DropdownButton<String>(
                        value: _selectedSex,
                        elevation: 16,
                        onChanged: (String newValue) {
                          setState(() {
                            sex = newValue;
                            _selectedSex = newValue;
                          });
                        },
                        items:
                            _sex.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        "Activity Level",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                      DropdownButton(
                        value: _selectedActivityLevel,
                        elevation: 16,
                        onChanged: (newValue) {
                          setState(() {
                            activityLevel = newValue;
                            _selectedActivityLevel = newValue;
                          });
                        },
                        items: _activity.map((location) {
                          return DropdownMenuItem(
                            child: new Text(location),
                            value: location,
                          );
                        }).toList(),
                      ),
                      TextFormField(
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(labelText: 'Description'),
                          controller: petDescription),
                      SizedBox(
                        height: 15.0,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                              child: Text('Submit'),
                              color: Theme.of(context).buttonColor,
                              onPressed: () {
                                saveEdit(context);
                              }),
                        ],
                      )
                    ]),
              )
            ])));
  }

  saveEdit(BuildContext context) async {
    DocumentReference ref =
        Firestore.instance.collection("pets").document(petID);
    await ref.updateData({
      "age": int.parse(petAge.text),
      "breed": selectedBreedType,
      "description": petDescription.text,
      "name": petName.text,
      "sex": sex,
      "type": type == "" ? otherTypeString.text : type,
      "image": image,
    });
    store.dispatch(new UpdateUserAction(null, {}));
    store.dispatch(new UpdateUserPetAction({}));
    store.dispatch(getFirebaseUser);
    Navigator.pop(context);
  }
}
