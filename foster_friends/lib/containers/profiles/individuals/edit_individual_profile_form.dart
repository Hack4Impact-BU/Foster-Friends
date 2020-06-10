import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:foster_friends/state/appState.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foster_friends/database.dart';

String name;
String email;
String phoneNumber;

class EditIndividualProfileForm extends StatefulWidget {
  @override
  final data;
  EditIndividualProfileForm(this.data);

  EditIndividualProfileFormState createState() {
    return EditIndividualProfileFormState(this.data);
  }
}

class EditIndividualProfileFormState extends State<EditIndividualProfileForm>{
  Map<String, dynamic> data;
  EditIndividualProfileFormState(this.data);

  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    final data = store.state.userData;
    name = data['name'];
    email = data['email'];
    phoneNumber = data['phone number'];
  }
  
  @override
  void dispose() {
    // store.dispatch(getFirebaseUser);
    super.dispose();
  }

  bool _anyAreNull() {
    final data = store.state.userData;

    return data['name'] == null ||
        data['email'] == null ||
        data['phone number'] == null;
  }


  
  @override 
  Widget build(BuildContext context){
    return Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      initialValue: name,
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
                      initialValue: email,
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
                      initialValue: phoneNumber,
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
    );
  }
}
