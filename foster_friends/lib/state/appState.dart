import 'package:redux_thunk/redux_thunk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'package:foster_friends/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foster_friends/containers/authentication/authentication.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

final ref = Firestore.instance;
Geoflutterfire geo = Geoflutterfire();

// AppState
class AppState {
  FirebaseUser _user;
  Map<String, dynamic> _userData;
  List<Map<String, dynamic>> _query;

  FirebaseUser get user => _user;
  Map<String, dynamic> get userData => _userData;
  List<Map<String, dynamic>> get query => _query;

  AppState(this._user, this._userData, this._query);

  get index => null;
}

/* --------------------- USER AUTHENTICATION --------------------- */
// User information class
class UpdateUserAction {
  FirebaseUser _user;
  Map<String, dynamic> _userData;

  FirebaseUser get user => this._user;
  Map<String, dynamic> get userData => this._userData;

  UpdateUserAction(this._user, this._userData);
}

// Async function that pulls user profile from database
ThunkAction<AppState> getFirebaseUser = (Store<AppState> store) async {
//  await signOut();
  FirebaseAuth.instance.currentUser().then((u) async {
    if (u == null) {
      store.dispatch(new UpdateUserAction(null, null));
    } else {
      final data = await getUserData(u.uid);

      store.dispatch(new UpdateUserAction(u, data));
    }
  });
};

/* --------------------- QUERIES  --------------------- */
// Query class --> holds results of a query and updates UI
class UpdateQueryAction {
  List<Map<String, dynamic>> _results;
  List<Map<String, dynamic>> get results => this._results;

  UpdateQueryAction(this._results);
}

// async function that pulls data based on query from database
ThunkActionWithExtraArgument<AppState, Map<String, dynamic>> makeQuery =
    (Store<AppState> store, Map<String, dynamic> params) async {
  /* 
    Firebase Query of:
    'Type', 'Breed', 'Sex', 'Age', 'Shelter', 'Address'
    Dispatches new information unto QueryViewModel
  */
  print("Search params are $params");
  List<Map<String, dynamic>> petInfo = await databaseQuery(params);

  print("$petInfo");
  if (petInfo.isEmpty) {
    store.dispatch(new UpdateQueryAction([{}]));
    print([{}].isEmpty);
  } else {
    store.dispatch(new UpdateQueryAction(petInfo));
  }
};

/* --------------------- REDUCER: HANDLES ACTION TYPES  --------------------- */
AppState reducer(AppState prev, dynamic action) {
  if (action is UpdateUserAction) {
    AppState newAppState =
        new AppState(action.user, action.userData, prev._query);
    return newAppState;
  } else if (action is UpdateQueryAction) {
    AppState newAppState =
        new AppState(prev.user, prev.userData, action.results);
    return newAppState;
  } else {
    return prev;
  }
}

/* --------------------- INITIALIZATION OF STORE  --------------------- */
final store = new Store<AppState>(reducer,
    initialState: new AppState(null, null, []), middleware: [thunkMiddleware]);
