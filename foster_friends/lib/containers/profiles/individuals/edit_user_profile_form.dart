import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

FirebaseUser user;
String uid;

class EditUserProfileForm extends StatefulWidget {
  @override
  EditUserProfileFormState createState() {
    return EditUserProfileFormState();
  }
}

class EditUserProfileFormState extends State<EditUserProfileForm>{
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _email;
  String _phoneNum;
  String _location;

  void initState() {
    super.initState();
    getUser();
    uid = "UbHepIQJN5XiRaxKD3xALVgRvEJ3";
  }
  
  @override 
  Widget build(BuildContext context){
    return StreamBuilder(
      stream: Firestore.instance.collection("individuals").document(uid).snapshots(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          _name = snapshot.data["name"];
          _email = snapshot.data["email"];
          _phoneNum = snapshot.data["phone number"];
          _location = snapshot.data["location"];
          return Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      initialValue: _name,
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
                      initialValue: _email,
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
                      initialValue: _phoneNum,
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
                    TextFormField(
                      initialValue: _location,
                      style: TextStyle(fontSize:18),
                      decoration: 
                        InputDecoration(
                          labelText: "Location",
                          labelStyle: TextStyle(fontSize:20),
                          icon: Icon(Icons.location_city)
                          ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your location';
                        }
                        return null;
                      },
                      onChanged: (value) => setState(() => _location = value),
                    ),
                  ],),
                )
          );
        }
        else{
          return CircularProgressIndicator();
        }
      }
    );
    
  }

  void getUser() async {
    user = await FirebaseAuth.instance.currentUser();
  }
}