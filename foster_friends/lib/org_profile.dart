import 'package:flutter/material.dart';

// Define a custom Form widget.
class Org_Profile extends StatefulWidget {
  @override
  Org_state createState() {
    return Org_state();
  }
}


class Org_state extends State<Org_Profile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            body: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      CircleAvatar(
                        radius:70,
                        backgroundImage: NetworkImage("https://www.logolynx.com/images/logolynx/s_fc/fc0e9c5a08b6da8c96386f35c4c500f2.jpeg"),
                        
                      ),

                      Text("Boston Animal Shelter",
                      style: Theme.of(context).textTheme.title
                      ),
                      Text("Dog animal shelter based in Boston, Massachussetts. Connecting reescue dogs to loving families.",
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'roboto',
                        fontSize: 15.0,
                        letterSpacing: 1.5
                      ),
                      textAlign: TextAlign.center
                      ),

                      Divider(color: Colors.grey),
                      
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        width: 400.0,
                        height: 400.0,
                        child: _buildGrid(context)
                      ),
      
                    ]))));
  }
}

Widget _buildGrid(BuildContext context) => GridView.count(
  shrinkWrap: true,
      crossAxisCount: 3,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.all(4),
      children: _buildGridTileList(5,context));


  List<Widget> _buildGridTileList(int count,BuildContext context) => List.generate(
      count, (i)
      {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container( 
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:NetworkImage("https://hips.hearstapps.com/ghk.h-cdn.co/assets/17/30/2560x1280/landscape-1500925839-golden-retriever-puppy.jpg?resize=1200:*"),
                  fit:BoxFit.cover
                ),
                borderRadius: BorderRadius.all(Radius.circular(100))),
              child: FlatButton(
                child: null,
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                   Navigator.pushNamed(context, '/Pet_Profile');
                        
                },
              )
              
              ),
          ),
        );
      });
