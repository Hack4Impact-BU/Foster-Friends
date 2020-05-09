import 'package:flutter/material.dart';

// Define a custom Form widget.
class PetProfile extends StatefulWidget {
  @override
  PetState createState() {
    return PetState();
  }
}

class PetInfo {
  PetInfo([ this.name, this.description, this.breed, this.sex, this.organization, this.type, this.age, this.photo]);
  final String name;
  final String breed;
  final String photo;
  final String organization; 
  final String sex; 
  //final String location; 
  final String type; 
  final String description;
  final String age;

}



class PetState extends State<PetProfile> {
   
  Map data = {};

  @override
  Widget build(BuildContext context) {

  PetInfo p;
  data = ModalRoute.of(context).settings.arguments;
  print(data);
  if(data['Sex'] == true) {
    p = new PetInfo(data['Name'],data['Description'],data['Breed'],"Female",data['Organization'],data['Type'],data['Age'],data['Photo']);
  }
  else{
    p = new PetInfo(data['Name'],data['Description'],data['Breed'],"Male",data['Organization'],data['Type'],data['Age'],data['Photo']);
  }

    return Container(
        child: Scaffold(
          appBar: AppBar(),
          
            body: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  
                  children: <Widget> [ 
                      
                          Image.network(
                            p.photo, 
                            height: 200,
                            width: 400,

                            fit: BoxFit.cover),

                    SizedBox(height: 30),
                        Text(p.name, 
                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'roboto',
                                        fontSize: 50.0,
                                        letterSpacing: 1.5)
                      ),        
                      SizedBox(height: 20),

                      Text(p.description, 
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'roboto',
                        fontSize: 15.0,
                        letterSpacing: 1.5
                      ),
                          ),
                          
                          SizedBox(height: 30),

                      FlatButton(
                        child: Text('Edit Pet Profile'),
                        color: Colors.black12,
                        onPressed: () {Navigator.pushNamed(context, '/Edit_Pet_Profile',arguments: data);}
                      ),
                      Divider(color: Colors.grey),
                      SizedBox(height: 30),

                      Container(
                      margin: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text("Pet Type", 
                            style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'roboto',
                            fontSize: 15.0,
                            letterSpacing: 1.5
                            )),

                            Text(p.type, 
                            style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'roboto',
                            fontSize: 15.0,
                            letterSpacing: 1.5
                            ))
                        
                          ]),
                          SizedBox(width: 20),

                          Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text("Breed", 
                            style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'roboto',
                            fontSize: 15.0,
                            letterSpacing: 1.5
                            )),

                            Text(p.breed, 
                            style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'roboto',
                            fontSize: 15.0,
                            letterSpacing: 1.5
                            ))
                        
                          ]),

                         SizedBox(width: 20),

                          Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text("Gender", 
                            style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'roboto',
                            fontSize: 15.0,
                            letterSpacing: 1.5
                            )),

                            Text(p.sex, 
                            style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'roboto',
                            fontSize: 15.0,
                            letterSpacing: 1.5
                            ))
                        
                          ]),

SizedBox(width: 20),
                          Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text("Age", 
                            style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'roboto',
                            fontSize: 15.0,
                            letterSpacing: 1.5
                            )),

                            Text(p.age, 
                            style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'roboto',
                            fontSize: 15.0,
                            letterSpacing: 1.5
                            ))
                        
                          ]),
                        ],
                      )

                      

                      // Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: <Widget>[
                      //     Text("Gender:", 
                      // style: TextStyle(
                      //   color: Colors.red,
                      //   fontFamily: 'roboto',
                      //   fontSize: 20.0,
                      //   letterSpacing: 1.5
                      // )),

                      // Text(p.sex, 
                      // style: TextStyle(
                      //   color: Colors.black,
                      //   fontFamily: 'roboto',
                      //   fontSize: 20.0,
                      //   letterSpacing: 1.5
                      // ))]),

                      //     SizedBox(height: 30),

                      // Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: <Widget>[
                      //     Text("Age:", 
                      // style: TextStyle(
                      //   color: Colors.red,
                      //   fontFamily: 'roboto',
                      //   fontSize: 20.0,
                      //   letterSpacing: 1.5
                      // )),

                      // Text(p.age, 
                      // style: TextStyle(
                      //   color: Colors.black,
                      //   fontFamily: 'roboto',
                      //   fontSize: 20.0,
                      //   letterSpacing: 1.5
                      // ))]),
                      
                      // ]))
                      )
                  ]))));
  }
}

