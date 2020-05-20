import 'package:flutter/material.dart';
// import 'package:foster_friends/containers/profiles/organizations/pet_profile.dart';
// import 'package:f'

// Define a custom Form widget.
class PetProfile extends StatefulWidget {
  final data;

  PetProfile(this.data);
  @override
  PetState createState() {
    return PetState(this.data);
  }
}


class PetState extends State<PetProfile> {
  Map data;

  PetState(this.data);

  TextStyle _label = TextStyle(
      color: Colors.redAccent, decoration: TextDecoration.none, fontSize: 20.0);
  TextStyle _data = TextStyle(
      color: Colors.black, decoration: TextDecoration.none, fontSize: 20.0);

  @override
  initState(){
    print(this.data);
  }
  Widget _header() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.network(data['image'],
            height: 200, width: 200, fit: BoxFit.scaleDown),
        SizedBox(height: 30),
        Text(data['name'],
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'roboto',
                fontSize: 50.0,
                letterSpacing: 1.5)),
        SizedBox(height: 20),
        Text(data['description'], style: _data),
        SizedBox(height: 30)
      ],
    );
  }

  Widget _details(Map data) {
    /* 
    'Type', 'Breed', 'Sex', 'Age', 'Shelter', 'Address'
    */
    print(data);
    List details = ['Type', 'Breed', 'Sex', 'Age', 'Shelter', 'Address'];
    List databaseFields = [
      'type',
      'breed',
      'sex',
      'age',
      'organization',
      'orgAddress'
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _detail(details[0], data[databaseFields[0]]),
        _detail(details[1], data[databaseFields[1]]),
        _detail(details[2], data[databaseFields[2]]),
        _detail(details[3], data[databaseFields[3]].toString() ),
        _detail(details[4], data[databaseFields[4]]),
        _detail(details[5], data[databaseFields[5]])
      ],
    );
  }

  Widget _detail(String label, String data) {
    return Center(
      child: Row(
      children: <Widget>[
        Container(
          width: 150.0,
          padding: EdgeInsets.all(10),
          child: Text(
            label,
            style: _label,
          ),
        ),
        Text(
          data,
          style: _data,
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

    return Container(
        color: Colors.white,
        margin: EdgeInsets.all(20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _header(),
              Divider(color: Colors.grey),
              SizedBox(height: 30),
              _details(data),
              // _details(data['type'], data['breed'], data['sex'], data['age'], data['organization'], data['orgAddress'])
            ]));
  }
}
