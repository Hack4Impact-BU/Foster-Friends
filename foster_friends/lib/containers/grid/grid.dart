import 'package:flutter/material.dart';
import 'package:foster_friends/containers/profiles/pets/pet_profile.dart';
import 'package:foster_friends/state/appState.dart';

Widget buildGrid(List<Map<String, dynamic>> posts, BuildContext context,
        Map<String, dynamic> user) =>
    GridView.count(
        crossAxisCount: 3,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(4),
        children: buildGridTileList(posts, context, user));

List<Widget> buildGridTileList(List<Map<String, dynamic>> posts,
    BuildContext context, Map<String, dynamic> user) {
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
                    image: NetworkImage(posts[i]['image']), fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(100))),
            child: FlatButton(
              child: null,
              padding: EdgeInsets.all(0.0),
              onPressed: () async {
                store.dispatch(new UpdateUserPetAction({}));
                // store.dispatch(getFirebaseUserPet(store, posts[i]['orgId']));
                await getFirebaseUserPet(store, posts[i]['orgId']);

                // store.dispatch(new UpdateUserAction(null,{}));
                store.dispatch(getFirebaseUser);
                // print(store.state.userPetData);
                // print(user);
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        PetProfile(posts[i], user));
              },
            )),
      ),
    );
  });
}
