import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './edit_user_profile_form.dart';

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
              style: TextStyle(fontSize: 20.0, color: Colors.blue),
              ),
            )
        ]
        ),
      
      
      );
  }
}