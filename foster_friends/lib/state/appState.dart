import 'package:foster_friends/containers/profiles/image.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'package:foster_friends/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final ref = Firestore.instance;

// AppState
class AppState {
  FirebaseUser _user;
  Map<String, dynamic> _userData;
  List<Map<String, dynamic>> _query;
  int _userIndex;

  FirebaseUser get user => _user;
  Map<String, dynamic> get userData => _userData;
  List<Map<String, dynamic>> get query => _query;
  int get userIndex => this._userIndex;

  AppState(this._user, this._userData, this._query, this._userIndex);

  get index => null;
}

/* --------------------- USER AUTHENTICATION --------------------- */
// User information class
class UpdateUserAction {
  FirebaseUser _user;
  Map<String, dynamic> _userData;
  int _userIndex;

  FirebaseUser get user => this._user;
  Map<String, dynamic> get userData => this._userData;
  int get userIndex => this._userIndex;

  UpdateUserAction(this._user, this._userData, this._userIndex);
}

// Async function that pulls user profile from database
ThunkAction<AppState> getFirebaseUser = (Store<AppState> store) async {
  // await signOut();
  FirebaseAuth.instance.currentUser().then((u) async {
    if (u == null) {
      store.dispatch(new UpdateUserAction(null, null, 1));
    } else {
      final data = await getUserData(u.uid);

      store.dispatch(new UpdateUserAction(u, data, 1));
    }
  });
};

/* --------------------- QUERIES  --------------------- */
// Query class --> holds results of a query
class UpdateQueryAction {
  List<Map<String, dynamic>> _results;
  List<Map<String, dynamic>> get results => this._results;

  UpdateQueryAction(this._results);
}

class QueryAction {
  String param;

  QueryAction(this.param);
}

// async function that pulls data based on query from database
ThunkActionWithExtraArgument<AppState, Map<String, String>> makeQuery =
    (Store<AppState> store, Map<String, String> params) async {
  List<Map<String, dynamic>> petInfo = [];

  if (params.isEmpty) {
    petInfo = await getAllPets();
  } else {
    CollectionReference pets = ref.collection('pets');
    QuerySnapshot result =
        await pets.where('type', isEqualTo: params['type']).getDocuments();

    for (var snapshot in result.documents) {
      Map<String, dynamic> pet = Map.from(snapshot.data);
      pet['image'] = await getNetworkUrl(pet['image']);
      petInfo.add(pet);
    }
  }

  store.dispatch(new UpdateQueryAction(petInfo));
};

Future<List<Map<String, dynamic>>> getAllPets() async {
  List<Map<String, dynamic>> petInfo = [];

  // The syntax for the query should be something like this:
  CollectionReference pets = ref.collection('pets');
  QuerySnapshot result =
      await pets.getDocuments();

  for (var snapshot in result.documents) {
    Map<String, dynamic> pet = Map.from(snapshot.data);
    pet['image'] = await getNetworkUrl(pet['image']);
    petInfo.add(pet);
  }

  return petInfo;
}

/* --------------------- REDUCER: HANDLES ACTION TYPES  --------------------- */
AppState reducer(AppState prev, dynamic action) {
  if (action is UpdateUserAction) {
    AppState newAppState = new AppState(
        action.user, action.userData, prev._query, action.userIndex);
    return newAppState;
  } else if (action is UpdateQueryAction) {
    AppState newAppState =
        new AppState(prev.user, prev.userData, action.results, prev.userIndex);
    return newAppState;
    // } else if (action is QueryAction) {
    //   // Query action has a param
    //   // asynchronius function --> return some result
    //   // Return AppState with result (, , resultOfFunction)
    //   try {
    //     makeQuery(action.param).then((result) {
    //       print('REsult is $result');
    //       return new AppState(prev.user, prev.userData, result, prev.index);
    //     });
    //   } catch (error) {
    //     print("Error: $error");
    //   }
  } else {
    return prev;
  }
}

/* --------------------- INITIALIZATION OF STORE  --------------------- */
final store = new Store<AppState>(reducer,
    initialState: new AppState(null, null, [], 0),
    middleware: [thunkMiddleware]);
