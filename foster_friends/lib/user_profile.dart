import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:foster_friends/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseUser user;
String uid = "";
// Define a custom Form widget.
class UserProfile extends StatefulWidget {
  @override
  UserState createState() {
    return UserState();
  }
}

class UserState extends State<UserProfile>{

  // String _email;
  // String _phoneNumber;
  // String _location;
  // void getUserInfo() async {
  //   user  = await FirebaseAuth.instance.currentUser();
  //   var temp = Firestore.instance.collection("individuals").snapshots();
  //   _email = temp.data.documents[user.uid]['email'];
  //   _phoneNumber = temp.data.documents[user.uid]['phone number'];
  //   _location = temp.data.documents[user.uid]['location'];
  // }
  void initState() {
    super.initState();
    getUser();
    uid = "UbHepIQJN5XiRaxKD3xALVgRvEJ3";
  }
  // String uid = "UbHepIQJN5XiRaxKD3xALVgRvEJ3";
  @override
  Widget build(BuildContext context) {
    print("User ID is: " + uid);
      return StreamBuilder(
        stream: Firestore.instance.collection("individuals").document(uid).snapshots(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            String name = snapshot.data['name'];
            String email = snapshot.data['email'];
            String phoneNum = snapshot.data['phone number'];
            return Scaffold(
              body: ListView(
                children: <Widget>[
                  Container(child: Column(
                    children: <Widget>[
                      SizedBox(height: 20,),
                      CircleAvatar(
                        radius:70,
                        backgroundImage: NetworkImage("https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50"),
                      ),
                      SizedBox(height: 20,),
                      // getUserInfo(),
                      Text(name, style: TextStyle(fontWeight: FontWeight.w600, fontSize:20)),
                      SizedBox(height: 10,),
                      Container(margin: EdgeInsets.symmetric(horizontal: 16), child: Column(children: <Widget>[
                        // Text("Psychiatrist, pet lover, dogs > cat, looking for a pet to impress my girl", style: TextStyle(fontSize:18)),
                        // SizedBox(height:15,),
                        Text(email, style: TextStyle(fontSize:18)),
                        Text(phoneNum, style: TextStyle(fontSize:18)),
                        Text("Boston, MA", style: TextStyle(fontSize:18)),
                      ],))
                    ],
                    )
                  ),
                  // Container(child: Wrap(
                  //   runSpacing: 1.0,
                  //   spacing: 1.0,
                  //   children: <Widget>[
                  //     for(int i=0; i<8; i++)
                  //       Container(
                  //         height: MediaQuery.of(context).size.width/3,
                  //         width: MediaQuery.of(context).size.width/3,
                  //         decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/dog.png"), fit: BoxFit.cover)),
                  //       )
                  //   ],
                  //   )
                  // )
                  Padding(
                        padding: const EdgeInsets.all(8),
                        child: Center(
                            child: OutlineButton(
                              borderSide: BorderSide(color: Colors.grey),
                              color: Theme.of(context).buttonColor,
                                onPressed: () {
                                  print("Pressed edit profile");
                                  Navigator.pushNamed(  context, '/Edit_User_Profile');
                                  },
                                
                                child: Text("Edit Profile",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                        ))),
                  SizedBox(height: 15,),
                  GridView.count(
                    crossAxisCount: 3,
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    mainAxisSpacing: 1.5,
                    crossAxisSpacing: 1.5,
                    children: <Widget>[
                      for(int i=0; i<10; i++)
                        Container(
                          // height: MediaQuery.of(context).size.width/3,
                          // width: MediaQuery.of(context).size.width/3,
                          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/dog.png"), fit: BoxFit.cover)),
                        )
                    ],
                  )
                ],
              ),
            );
          }
          else{
            return new Text("Loading");
          }
        }
      );
      

  }
    
  void getUser() async {
    user = await FirebaseAuth.instance.currentUser();
  }
}