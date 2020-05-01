
import 'package:flutter/material.dart';
import 'package:foster_friends/org_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Define a custom Form widget.
class EditPetProfile extends StatefulWidget {
  @override
  EditPetState createState() {
    return EditPetState();
  }
}

  String name;
  String breed;
  String photo; 
  bool sex; 
  bool sex_final = sex;
  String sex_str;
  String type; 
  String description;
  String age;
  String petID;
  List pets = [];
  

  //fror curreent dropdown item
  String _selectedPetTypes = type;
  String _selectedBreedTypes;
  String _selectedSex = sex_str;

  List<String> _petTypes = ['Dog', 'Cat', 'Bird'];
  List<String> _sex = ['Female','Male'];

  class EditPetState extends State<EditPetProfile> {

  final petAge = TextEditingController();
  final petBreed = TextEditingController();
  final petDescription = TextEditingController();
  final petName = TextEditingController();


    Map data = {};
    

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
       photo = fileName;
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

    data = ModalRoute.of(context).settings.arguments;

    //setting local variables
    name = data['Name'];
    breed = data['Breed'];
    sex =data['Sex'];
    type =data['Type'];
    description =data['Description'];
    age =data['Age'];
    photo = data['Photo'];
    petID = data['ID'];
   

    //converting bool sex to string
    if(sex == true)
    sex_str = "Female";
    else
    sex_str = "Male";


   
    //setting initial text field values
    petName.text = name;
    petDescription.text = description;
    petAge.text = age;
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
                                        deletePet(context);
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
                                  photo,
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
                        if (newValue == 'Male')
                        sex_final = false;
                        else
                        sex_final = true;

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

  deletePet (BuildContext context) async {

    DocumentReference ref1 = Firestore.instance.collection("petstest").document(petID);
    DocumentReference ref2 = Firestore.instance.collection("organizations").document("IahwMOjwYdgEKY2cli5f");

    await ref2.get()
        .then((DocumentSnapshot snapshot)  {
        pets = snapshot.data['pets'];
        });

    pets.removeWhere((item) => item == petID);

    await ref1.delete();
    await ref2.updateData({
      "pets" : pets

    });


    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => OrgProfile()),
  ModalRoute.withName('/'),
);
  }


  saveEdit (BuildContext context) async {


        DocumentReference ref = Firestore.instance.collection("petstest").document(petID);
        uploadPic(context);
        await ref.updateData({
               
                "Age": petAge.text,
                "Breed": petBreed.text,
                "Description": petDescription.text,
                "Name": petName.text,
                "Sex": sex_final,
                "Type": _selectedPetTypes,
                "Photo": photo,
              });
              
        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => OrgProfile()),
        ModalRoute.withName('/'),
        );
      }
}

