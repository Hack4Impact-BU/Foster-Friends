import 'package:redux_thunk/redux_thunk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'package:foster_friends/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

final ref = Firestore.instance;
Geoflutterfire geo = Geoflutterfire();

// AppState
class AppState {
  FirebaseUser _user;
  Map<String, dynamic> _userData;
  Map<String, dynamic> _userPetData;
  List<Map<String, dynamic>> _query;

  FirebaseUser get user => _user;
  Map<String, dynamic> get userData => _userData;
  Map<String, dynamic> get userPetData => _userPetData;
  List<Map<String, dynamic>> get query => _query;

  AppState(this._user, this._userData, this._userPetData, this._query);

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
  FirebaseAuth.instance.currentUser().then((u) async {
    if (u == null) {
      store.dispatch(new UpdateUserAction(null, {}));
    } else {
      final data = await getUserData(u.uid);
      store.dispatch(new UpdateUserAction(u, data));
    }
  });
};

/* --------------------- USER PET --------------------- */
// User information class
class UpdateUserPetAction {
  Map<String, dynamic> _userPetData;

  Map<String, dynamic> get userPetData => this._userPetData;
  UpdateUserPetAction(this._userPetData);
}

// Async function that pulls user profile from database
ThunkActionWithExtraArgument<AppState, String> getFirebaseUserPet = (Store<AppState> store, String uid) async {
  // print("uid");
  // print(uid);
  if (uid == null) {
    store.dispatch(new UpdateUserPetAction({}));
  } else {
    final data = await getUserPetData(uid);
    store.dispatch(new UpdateUserPetAction(data));
  }
};

/* --------------------- QUERIES  --------------------- */
// Query class --> holds results of a query and updates UI
class UpdateQueryAction {
  List<Map<String, dynamic>> _results;
  List<Map<String, dynamic>> get results => this._results;
  UpdateQueryAction(this._results);
}

// async function that pulls data based on query from database
ThunkActionWithExtraArgument<AppState, Map<String, dynamic>> makeQuery = (Store<AppState> store, Map<String, dynamic> params) async {
  /* 
    Firebase Query of:
    'Type', 'Breed', 'Sex', 'Age', 'Shelter', 'Address'
    Dispatches new information unto QueryViewModel
  */
  List<Map<String, dynamic>> petInfo = await databaseQuery(params);
  if (petInfo.isEmpty) {
    store.dispatch(new UpdateQueryAction([{}]));
  } else {
    store.dispatch(new UpdateQueryAction(petInfo));
  }
};

/* --------------------- REDUCER: HANDLES ACTION TYPES  --------------------- */
AppState reducer(AppState prev, dynamic action) {
  if (action is UpdateUserAction) {
    AppState newAppState = new AppState(action.user, action.userData, prev.userPetData, prev._query);
    return newAppState;
  } else if (action is UpdateUserPetAction) {
    AppState newAppState = new AppState(prev.user, prev.userData, action.userPetData, prev._query);
    return newAppState;
  } else if (action is UpdateQueryAction) {
    AppState newAppState = new AppState(prev.user, prev.userData, prev.userPetData, action.results);
    return newAppState;
  } else {
    return prev;
  }
}

/* --------------------- INITIALIZATION OF STORE  --------------------- */
final store = new Store<AppState>(reducer, initialState: new AppState(null, null, null, []), middleware: [thunkMiddleware]);
