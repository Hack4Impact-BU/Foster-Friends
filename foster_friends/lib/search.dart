//import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';

// Empty search page

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Search',
        home: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Search'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                title: Text('Profile'),
              ),
            ],
            currentIndex: 0,
            selectedItemColor: Colors.amber[800],
            // onTap: _onItemTapped,
          ),
        ));
  }
}
// Future<List<Post>> search(String search) async {
// await Future.delayed(Duration(seconds: 2));
// return List.generate(search.length, (int index) {
//   print("Searching");
//   return Post(
//     "Title : $search $index",
//     "Description :$search $index",
//   );
// });
// }
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: SearchBar<Post>(
//             onSearch: search),
//         ),
//       ),
//     );
//   }
// }

// class Post {
//   final String title;
//   final String description;

//   Post(this.title, this.description);
// }
