import 'package:flutter/material.dart';
import './uploadPetForm.dart';
import 'package:foster_friends/main.dart';


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
    const List<Color> orangeGradients = [
      Color(0xFFFFCC80),
      Color(0xFFFE8853),
      Color(0xFFFEF5350),
    ];
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0), 
          child: AppBar(
        title: const Text('Foster Friends'), // top bar
        //backgroundColor: Color(0xFFFFCC80),
        flexibleSpace: 
          ClipPath(
              clipper: TopWaveClipper(),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: orangeGradients,
                      begin: Alignment.topLeft,
                      end: Alignment.center),
                ),
                height: MediaQuery.of(context).size.height / 7.5,
              ),
            ),
        
      )),
      body: ListView(
        children: <Widget>[
            Container(
                margin: EdgeInsets.all(20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      UploadPetForm(),
                      
                      
                    ]))]));
  }
}