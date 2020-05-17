import 'package:flutter/material.dart';
import 'package:foster_friends/database.dart';
import './uploadPet.dart';
import 'package:foster_friends/containers/authentication/authentication.dart';

import 'package:foster_friends/state/appState.dart';

final name = store.state.userData['name'];
final email = store.state.userData['email'];
final phoneNumber = store.state.userData['phone number'];
final description = store.state.userData['description'];


List pets = [];
List<Map<String, dynamic>> petInfo = [];
Map<String, dynamic> orgInfo;

// Define a custom Form widget.
class OrgProfile extends StatefulWidget {
  @override
  OrgState createState() {
    return OrgState();
  }
}

class OrgState extends State<OrgProfile> {
  @override
  void initState() {
    super.initState();
    petInfo = [];
    getData();
  }

  Widget build(BuildContext context) {

    if (orgInfo == null) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Loading..."),
        ),
      );
    } else {
    return Container(
        child: Scaffold(
            body: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(orgInfo['photo']),
                      ),
                      Text(orgInfo['name'], style: Theme.of(context).textTheme.title),
                      Text(orgInfo['description'],
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'roboto',
                              fontSize: 15.0,
                              letterSpacing: 1.5),
                          textAlign: TextAlign.center),
                      Row (
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: RaisedButton(
                            color: Theme.of(context).buttonColor,
                              onPressed: () {
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (BuildContext context) => new UploadPet()));
                                },
                              
                              child: Text("Upload Pet",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).backgroundColor)),
                                      ),),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: RaisedButton(
                            color: Theme.of(context).buttonColor,
                              onPressed: () {
                                signOut();
                              },
                              
                              child: Text("Sign Out",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).backgroundColor)),
                                      ))],),
                        Divider(color: Colors.grey),
                        Container(
                            margin: const EdgeInsets.all(10.0),
                            width: 400.0,
                            height: 393.0,
                            child: _buildGrid(context)),
                    ]))));}
  }

  getData() async {
    orgInfo = await getUserData("1HqRtP4hCbZqQswuMLHA");
    
    for (var i in orgInfo['pets']) {
         
         final pet = await getPetData(i);
         petInfo.add(pet);     }

         setState(() {});

  }

}

Widget _buildGrid(BuildContext context) => GridView.count(
    shrinkWrap: true,
    crossAxisCount: 3,
    scrollDirection: Axis.vertical,
    padding: const EdgeInsets.all(4),
    children: _buildGridTileList(petInfo.length, context));

List<Widget> _buildGridTileList(int count, BuildContext context) =>
    List.generate(count, (i) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(petInfo[i]['image']),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              child: FlatButton(
                child: null,
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  Navigator.pushNamed(context, '/Pet_Profile',
                      arguments: petInfo[i]);
                },
              )),
        ),
      );
    });
