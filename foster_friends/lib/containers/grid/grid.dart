import 'package:flutter/material.dart';
import 'package:foster_friends/containers/profiles/organizations/pet_profile.dart';

Widget buildGrid(List<Map<String, dynamic>> posts, BuildContext context) =>
    GridView.count(
        crossAxisCount: 3,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(4),
        children: buildGridTileList(posts, context));

List<Widget> buildGridTileList(
    List<Map<String, dynamic>> posts, BuildContext context) {
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
                    image: NetworkImage(chooseImage(posts[i]['image'])),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(100))),
            child: FlatButton(
              child: null,
              padding: EdgeInsets.all(0.0),
              onPressed: () {
                print("Show profile");
                // Navigator.pushNamed(context, '/Pet_Profile', arguments: posts[i]);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new PetProfile(posts[i])));
              },
            )),
      ),
    );
  });
}

String chooseImage(String url) {
  if (url == null) {
    return 'http://www.hostingreviewbox.com/wp-content/uploads/2016/02/image-error.png';
  } else if (url.length < 7) {
    return 'http://www.hostingreviewbox.com/wp-content/uploads/2016/02/image-error.png';
  } else if (url.substring(0, 8) != 'https://') {
    if (url.substring(0, 7) != 'http://') {
      return 'http://www.hostingreviewbox.com/wp-content/uploads/2016/02/image-error.png';
    }
  }
  return url;
}
