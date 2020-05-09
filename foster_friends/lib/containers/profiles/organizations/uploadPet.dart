import 'package:flutter/material.dart';
import './uploadPetForm.dart';


// Define a custom Form widget.
class UploadPet extends StatefulWidget {
  @override
  UploadPetState createState() {
    return UploadPetState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class UploadPetState extends State<UploadPet> {
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
        child: Scaffold(
            body: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      UploadPetForm(),
                      
                      
                    ]))));
  }
}