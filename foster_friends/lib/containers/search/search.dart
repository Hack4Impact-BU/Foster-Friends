import 'package:flutter/material.dart';
import 'package:foster_friends/containers/search/searchForm.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Container(
    //     child: SearchState(),
    //     padding: EdgeInsets.all(10),
    //     color: Colors.white,
    // );
    return Dialog(
      insetPadding: EdgeInsets.all(10),
      child: SingleChildScrollView(child: SearchForm()),
    );
  }
}

class SearchState extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchState> {
  String city; // Type in
  String temperament; // dropdown
  String type; // dropdown
  String breed; // Type in
  int ageMin; // Type in
  int ageMax; // Type
  int activityLevel; //

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Hello"),
        RaisedButton(
            child: Text("Find your best friend!"),
            onPressed: () {
              print("Searching");
            }),
        RaisedButton(
            child: Text("Cancel"),
            onPressed: () {
              print("hello");
            }),
      ],
    );
  }
}
