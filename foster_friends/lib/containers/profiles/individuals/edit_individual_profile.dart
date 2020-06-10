import 'package:flutter/material.dart';
import 'package:foster_friends/state/appState.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foster_friends/database.dart';
import './edit_individual_profile_form.dart';

String name;
String email;
String phoneNumber;
String photo;
//String description;

// Define a custom Form widget.
class EditIndividualProfile extends StatefulWidget {
  final data;
  EditIndividualProfile(this.data);

  @override
  EditIndividualState createState() {
    return EditIndividualState(this.data);
  }
}



class EditIndividualState extends State<EditIndividualProfile> {
  Map<String, dynamic> data;
  EditIndividualState(this.data);

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController phoneNumCon = TextEditingController();

  @override
  void initState() {
    super.initState();
    //setting local variables
    final data = store.state.userData;
    name = data['name'];
    email = data['email'];
    phoneNumber = data['phone number'];
    photo = data['photo'];

    nameCon = TextEditingController(text: name);
    emailCon = TextEditingController(text: email);
    phoneNumCon = TextEditingController(text: phoneNumber);
  }

  @override
  void dispose() {
    // store.dispatch(getFirebaseUser);
    super.dispose();
    nameCon.dispose();
    emailCon.dispose();
    phoneNumCon.dispose(); 
  }

  bool _anyAreNull() {
    final data = store.state.userData;

    return data['name'] == null ||
        data['email'] == null ||
        data['phone number'] == null ||
        data['photo'] == null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              print("Pressed done");
              saveEdit(context);
              // Navigator.of(context).pop();
            },
            child: Text("Done",
              style: TextStyle(fontSize: 20.0, color: Colors.red[500]),
              ),
            )
        ]
        ),
      body: ListView(
        children: <Widget>[
          Container(child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              CircleAvatar(
                radius:70,
                backgroundImage: NetworkImage(photo),
              ),
              // SizedBox(height: 20,),
              Center(
                child: FlatButton(
                  onPressed: (){
                    print("Pressed change profile photo");
                      
                  },
                  child: Text("Change Profile Photo",
                    style: TextStyle(fontSize: 18, color: Colors.red[500]),
                    ),
              ),),
              SizedBox(height: 10,),
              // EditIndividualProfileForm(this.data),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: 
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextFormField(
                          controller: nameCon,
                          // initialValue: name,
                          style: TextStyle(fontSize:18),
                          decoration:
                            InputDecoration(
                              labelText: "Name",
                              labelStyle: TextStyle(fontSize:20),
                              icon: Icon(Icons.person),
                              ),
                              
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: emailCon,
                          // initialValue: email,
                          style: TextStyle(fontSize:18),
                          keyboardType: TextInputType.emailAddress,
                          decoration: 
                            InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(fontSize:20),
                              icon: Icon(Icons.email)
                              ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your email';
                            }
                            else if (!value.contains("@")){
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: phoneNumCon,
                          // initialValue: phoneNumber,
                          style: TextStyle(fontSize:18),
                          keyboardType: TextInputType.number,
                          decoration: 
                            InputDecoration(
                              labelText: "Phone Number",
                              labelStyle: TextStyle(fontSize:20),
                              icon: Icon(Icons.phone)
                              ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        // TextFormField(
                        //   initialValue: location,
                        //   style: TextStyle(fontSize:18),
                        //   decoration: 
                        //     InputDecoration(
                        //       labelText: "Location",
                        //       labelStyle: TextStyle(fontSize:20),
                        //       icon: Icon(Icons.location_city)
                        //       ),
                        //   validator: (value) {
                        //     if (value.isEmpty) {
                        //       return 'Please enter your location';
                        //     }
                        //     return null;
                        //   },
                        //   onChanged: (value) => setState(() => location = value),
                        // ),
                      ],),
                    )
              ),
            ]
          ))
        ],)
      
      );
  } 
  saveEdit(BuildContext context) async {
    DocumentReference ref =
      Firestore.instance.collection("users").document(store.state.user.uid);
    await ref.updateData({
      "name": nameCon.text,
      "email": emailCon.text,
      "phone number": phoneNumCon.text,
    });
    store.dispatch(getFirebaseUser);
    Navigator.pushReplacementNamed(context, '/');
  }
}
