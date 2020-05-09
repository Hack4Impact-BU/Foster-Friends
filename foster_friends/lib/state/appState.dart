import 'package:redux_thunk/redux_thunk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'package:foster_friends/database.dart';

// AppState
class AppState {

  FirebaseUser _user;
  Map<String,dynamic> _userData;
  int _userIndex;

  FirebaseUser get user => _user;
  Map<String,dynamic> get userData => _userData;
  int get userIndex => this._userIndex;

  AppState(this._user, this._userData, this._userIndex);

  get index => null;
}

class UpdateUserAction {
  FirebaseUser _user;
  Map<String,dynamic> _userData;
  int _userIndex;

  FirebaseUser get user => this._user;
  Map<String,dynamic> get userData => this._userData;
  int get userIndex => this._userIndex;

  UpdateUserAction(this._user, this._userData, this._userIndex);
}

ThunkAction<AppState> getFirebaseUser = (Store<AppState> store) async {
  FirebaseAuth.instance.currentUser().then((u) async {
    
    if (u == null) {
      store.dispatch(new UpdateUserAction(null, null, 1));
    } else {
      final data = await getUserData(u.uid);
      print("User is $u with data $data");
      store.dispatch(new UpdateUserAction(u, data, 1));
    }
  });
};

// Reducer
AppState reducer(AppState prev, dynamic action) {
  if (action is UpdateUserAction) {
    AppState newAppState =
        new AppState(action.user, action.userData, action.userIndex);
    return newAppState;
  } else {
    return prev;
  }
}

// store that hold our current appstate
final store = new Store<AppState>(reducer,
    initialState: new AppState(null, null, 0), middleware: [thunkMiddleware]);
