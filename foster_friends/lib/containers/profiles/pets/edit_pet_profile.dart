
import 'package:flutter/material.dart';
import 'package:foster_friends/containers/profiles/organizations/org_profile.dart';
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
  String breed;
  String image; 
  String sex; 
  String type; 
  String description;
  int age;
  String petID;
  String organization;
  String orgAddress;
  String activityLevel;
  List pets = [];
  

  //for current dropdown item
  String _selectedPetTypes = type;
  String _selectedBreedTypes;
  String _selectedSex = sex;

  List<String> _petTypes = ['Dog', 'Cat', 'Bird'];
  List<String> _sex = ['Female','Male'];

  class EditPetState extends State<EditPetProfile> {

  final petAge = TextEditingController();
  final petBreed = TextEditingController();
  final petDescription = TextEditingController();
  final petName = TextEditingController();


  Map<String, dynamic> data;

  EditPetState(this.data);
    

// -------------------------- upload photo -------------------------------
  File _image;
  Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
          print('Image Path $_image');
      });
    }

    Future uploadPic(BuildContext context) async{
       String fileName = basename(_image.path);
       image = fileName;
       StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
       StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
       StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
       setState(() {
          print("Profile Picture uploaded");
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
       });
    }





  @override
  Widget build(BuildContext context) {

    // data = ModalRoute.of(context).settings.arguments;

    //setting local variables
    name = data['name'];
    breed = data['breed'].toString();
    sex =data['sex'];
    type =data['type'];
    description =data['description'];
    age =data['age'];
    image = data['image'];
    petID = data['id'];
    organization = data['organization'];
    orgAddress = data['orgAddress'];
    activityLevel = data['activityLevel'];
   

   
    //setting initial text field values
    petName.text = name;
    petDescription.text = description;
    petAge.text = age.toString();
    petBreed.text = breed;

    return Container(
        child: Scaffold(
          appBar: AppBar(),
            body: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[

                        FlatButton(
                          onPressed: () {
                            showDialog(context: context,
                            builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Are you sure?"),
                              actions: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    FlatButton(
                                      child: Text('Yes'),
                                      onPressed: () {
                                        deletePet(petID);
                                        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => OrgProfile()),
                                        ModalRoute.withName('/'));
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('No'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                                
                              ],
                            );
                            });
                          },
                          child: 
                            Text("Remove Pet Entry",
                            style: TextStyle(
                            color: Colors.red),
                            ),
                        )
                        
                        // IconButton(
                        //   icon: Icon(Icons.delete_outline,color: Colors.red),
                        //   iconSize: 20,
                        //   onPressed: null

                        // ),
                        
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
                                  child: (_image!=null)?Image.file(
                                    _image,
                                    fit: BoxFit.cover,
                                  ):Image.network(
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
                      decoration: InputDecoration(
                        labelText: 'Name'),
                    ),

                  TextFormField(
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: 'Description'),
                      controller: petDescription
                      
                    ),

                  SizedBox(
                      height: 15.0,
                    ),
                  Text("Type",
                  style: TextStyle(
                   color: Colors.black54,
                   fontSize: 12 ),
                  ),


                  DropdownButton<String>(
                    value: _selectedPetTypes,
                    
                    elevation: 16,
                    
                    onChanged: (String newValue) {
                      setState(() {
                        type = newValue;
                        
                        _selectedPetTypes = newValue;
                      });
                    },
                    items: _petTypes
                      .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      })
                      .toList(),
                  ),

                  
                  TextFormField(
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: 'Breed'),
                      controller: petBreed,
                    ),


                  SizedBox(
                      height: 15.0,
                    ),

                  Text("Sex",
                  style: TextStyle(
                   color: Colors.black54,
                   fontSize: 12 ),
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
                    items: _sex
                      .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      })
                      .toList(),
                  ),

                  TextFormField(
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: 'Age'),
                      controller: petAge,
                    ),
                  SizedBox(
                      height: 15.0,
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        child: Text('Submit'),
                            color: Colors.black12,
                            onPressed: () {
                               saveEdit(context);
                              
                              }
                      ),
                    ],
                  )
                  ]),
            )));        
  }


  saveEdit (BuildContext context) async {


        DocumentReference ref = Firestore.instance.collection("pets").document(petID);
        //uploadPic(context);
        await ref.updateData({
               
                "age": petAge.text,
                "breed": petBreed.text,
                "description": petDescription.text,
                "name": petName.text,
                "sex": sex,
                "type": _selectedPetTypes,
                "image": image,
              });
              
        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => OrgProfile()),
        ModalRoute.withName('/'),
        );
      }
}

