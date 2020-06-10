import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './edit_individual_profile_form.dart';

// Define a custom Form widget.
class EditUserProfile extends StatefulWidget {
  @override
  EditUserProfileState createState() {
    return EditUserProfileState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class EditUserProfileState extends State<EditUserProfile>{
  @override 
  Widget build(BuildContext context){
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              print("Pressed done");
              Navigator.pushNamed(  context, '/User_Profile');
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
                backgroundImage: NetworkImage("https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50"),
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
              // EditUserProfileForm(),
            ]
          ))
        ],)
      
      );
  }
}