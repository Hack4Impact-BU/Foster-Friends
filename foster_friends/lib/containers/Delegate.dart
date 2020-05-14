// //import 'package:flappy_search_bar/flappy_search_bar.dart';

// import 'package:flutter/material.dart';
// // import 'package:bloc/bloc.dart';

// // main application build
// class SearchCopy extends StatelessWidget {
//   static const String _title = 'Flutter Code Sample';

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: _title,
//       home: SearchCopyState(),
//     );
//   }
// }

// // building state
// class SearchCopyState extends StatefulWidget {
//   SearchCopyState({Key key}) : super(key: key); // have no idea what this is

//   @override
//   _SearchState createState() => _SearchState();
// }

// // This is the bottom bar body options
// class _SearchState extends State<SearchCopyState> {
//   int _selectedIndex = 0;
//   static const TextStyle optionStyle =
//       TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
//   static List<Widget> _widgetOptions = <Widget>[
//     Text(
//       'Search Page',
//       style: optionStyle,
//     ),
//     LoginPage(),
//     BadProfile()
//     // BadProfile()
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       // print('index'+index.toString());
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Foster Friends'), // top bar
//       ),
//       body: Center(
//         child: IconButton(
//           icon: Icon(Icons.search),
//           onPressed: () {
//             showSearch(
//               context: context, 
//               delegate: new Delegate("Search")
//             );
//           },
//         ),
//       ),
//   }



//   Widget search(BuildContext context) {
//     Delegate delegate = new Delegate("");
//     showSearch(context: context, delegate: delegate);
//     return null;
//   }

// }

// class Delegate extends SearchDelegate {

//   Delegate(String hintText) : super(
//     searchFieldLabel: hintText,
//     keyboardType: TextInputType.text,
//     textInputAction: TextInputAction.search,
//   );

//   Widget buildSuggestions(BuildContext context) {
//     return Column();
//   }

//   Widget buildResults(BuildContext context) {
//     if (query.length < 3) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Center(
//             child: Text(
//               "Search term must be longer than two letters.",
//             ),
//           )
//         ],
//       );
//     }

//     //Add the search term to the searchBloc. 
//     //The Bloc will then handle the searching and add the results to the searchResults stream.
//     //This is the equivalent of submitting the search term to whatever search service you are using
//     InheritedBlocs.of(context)
//         .searchBlocs
//         .searchTerm
//         .add(query);
//     return Column(
//       children: <Widget>[
//         //Build the results based on the searchResults stream in the searchBloc
//         StreamBuilder(
//           stream: InheritedBlocs.of(context).searchBloc.searchResults,
//           builder: (context, AsyncSnapshot<List<Result>> snapshot) {
//             if (!snapshot.hasData) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Center(child: CircularProgressIndicator()),
//                 ],
//               );
//             } else if (snapshot.data.length == 0) {
//               return Column(
//                 children: <Widget>[
//                   Text(
//                     "No Results Found.",
//                   ),
//                 ],
//               );
//             } else {
//               var results = snapshot.data;
//               return ListView.builder(
//                 itemCount: results.length,
//                 itemBuilder: (context, index) {
//                   var result = results[index];
//                   return ListTile(
//                     title: Text(result.title),
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       ],
//     );
//   }

//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   List<Widget> buildActions(BuildContext context) {
//      return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }
// }

// class InheritedBlocs extends InheritedWidget {
//   InheritedBlocs(
//       {Key key,
//       this.searchBloc,
//       this.child})
//       : super(key: key, child: child);

//   final Widget child;
//   final SearchBloc searchBloc;

//   static InheritedBlocs of(BuildContext context) {
//     return (context.dependOnInheritedWidgetOfExactType(InheritedBlocs)
//         as InheritedBlocs);
//   }

//   @override
//   bool updateShouldNotify(InheritedBlocs oldWidget) {
//     return true;
//   }
// }

// class SearchBloc extends Bloc<SearchEvent, SearchState> {
//   final YoutubeRepository _youtubeRepository;

//   SearchBloc(this._youtubeRepository) : super();

//   void onSearchInitiated(String query) {
//     dispatch(SearchInitiated((b) => b..query = query));
//   }

//   void fetchNextResultPage() {
//     dispatch(FetchNextResultPage());
//   }

//   @override
//   SearchState get initialState => SearchState.initial();

//   @override
//   Stream<SearchState> mapEventToState(
//       SearchState currentState, SearchEvent event) async* {
//     if (event is SearchInitiated) {
//       yield* mapSearchInitiated(event);
//     } else if (event is FetchNextResultPage) {
//       yield* mapFetchNextResultPage();
//     }
//   }

//   Stream<SearchState> mapSearchInitiated(SearchInitiated event) async* {
//     if (event.query.isEmpty) {
//       yield SearchState.initial();
//     } else {
//       yield SearchState.loading();

//       try {
//         final searchResult = await _youtubeRepository.searchVideos(event.query);
//         yield SearchState.success(searchResult);
//       } on YoutubeSearchError catch (e) {
//         yield SearchState.failure(e.message);
//       } on NoSearchResultsException catch (e) {
//         yield SearchState.failure(e.message);
//       }
//     }
//   }


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
