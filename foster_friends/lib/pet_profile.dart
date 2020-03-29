import 'package:flutter/material.dart';

// Define a custom Form widget.
class Pet_Profile extends StatefulWidget {
  @override
  Pet_state createState() {
    return Pet_state();
  }
}


class Pet_state extends State<Pet_Profile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
          appBar: AppBar(),
          
            body: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  
                  children: <Widget> [ 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          CircleAvatar(
                            radius:70,
                            backgroundImage:NetworkImage("https://hips.hearstapps.com/ghk.h-cdn.co/assets/17/30/2560x1280/landscape-1500925839-golden-retriever-puppy.jpg?resize=1200:*"),

                          ),
                          
                          Text("Lily", style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'roboto',
                                        fontSize: 50.0,
                                        letterSpacing: 1.5
                                      ),
                          ),
                          
                        ],
                      ),
                    SizedBox(height: 30),

                      Text("Playful golden Lab. Loves being scratched. Goodest girl. Will drown you with love.", 
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'roboto',
                        fontSize: 15.0,
                        letterSpacing: 1.5
                      ),
                          ),
                          
                          SizedBox(height: 30),
                      Divider(color: Colors.grey),
                      SizedBox(height: 30),

                      Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                  
                        children: <Widget> [ 


                          Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Pet Type:", 
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'roboto',
                        fontSize: 20.0,
                        letterSpacing: 1.5
                      )),

                      Text("Dog", 
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'roboto',
                        fontSize: 20.0,
                        letterSpacing: 1.5
                      ))]),

                          SizedBox(height: 30),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Breed:", 
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'roboto',
                        fontSize: 20.0,
                        letterSpacing: 1.5
                      )),

                      Text("Labrador Retrievers", 
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'roboto',
                        fontSize: 20.0,
                        letterSpacing: 1.5
                      ))]),

                                                SizedBox(height: 30),


                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Gender:", 
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'roboto',
                        fontSize: 20.0,
                        letterSpacing: 1.5
                      )),

                      Text("Female", 
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'roboto',
                        fontSize: 20.0,
                        letterSpacing: 1.5
                      ))]),

                          SizedBox(height: 30),

                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Age:", 
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'roboto',
                        fontSize: 20.0,
                        letterSpacing: 1.5
                      )),

                      Text("1 year, 2 months", 
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'roboto',
                        fontSize: 20.0,
                        letterSpacing: 1.5
                      ))]),
                      
                      ]))

                  ]))));
  }
}

