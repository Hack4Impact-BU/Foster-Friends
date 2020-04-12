import 'package:flutter/material.dart';

// Define a custom Form widget.
class UserProfile extends StatefulWidget {
  @override
  UserState createState() {
    return UserState();
  }
}

class UserState extends State<UserProfile>{
  @override
  Widget build(BuildContext context) {
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
              Text("John Doe", style: TextStyle(fontWeight: FontWeight.w600, fontSize:20)),
              SizedBox(height: 10,),
              Container(margin: EdgeInsets.symmetric(horizontal: 16), child: Column(children: <Widget>[
                // Text("Psychiatrist, pet lover, dogs > cat, looking for a pet to impress my girl", style: TextStyle(fontSize:18)),
                // SizedBox(height:15,),
                Text("johndoe@gmail.com", style: TextStyle(fontSize:18)),
                Text("626-215-2500", style: TextStyle(fontSize:18)),
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
}