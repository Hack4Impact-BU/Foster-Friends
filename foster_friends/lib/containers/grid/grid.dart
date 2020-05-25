import 'package:flutter/material.dart';
import 'package:foster_friends/containers/profiles/pets/pet_profile.dart';

Widget buildGrid(List<Map<String, dynamic>> posts, BuildContext context) => GridView.count(
    crossAxisCount: 3,
    scrollDirection: Axis.vertical,
    padding: const EdgeInsets.all(4),
    children: buildGridTileList(posts, context));

List<Widget> buildGridTileList(List<Map<String, dynamic>> posts, BuildContext context) {
  if (posts.length < 1) {
    return new List(0);
  }
  return List.generate(posts.length, (i) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipOval(
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(posts[i]['image']),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(100))),
            child: FlatButton(
              child: null,
              padding: EdgeInsets.all(0.0),
              onPressed: () {
                showDialog(context: context, builder: (BuildContext context) => PetProfile(posts[i]));
              },
            )),
      ),
    );
  });
}
