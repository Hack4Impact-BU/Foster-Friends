import 'package:redux_thunk/redux_thunk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'package:foster_friends/database.dart';

// AppState
class AppState {
  FirebaseUser _user;
  String _userType;
  int _userIndex;

  FirebaseUser get user => _user;
  String get userType => this._userType;
  int get userIndex => this._userIndex;

  AppState(this._user, this._userType, this._userIndex);

  get index => null;
}

class UpdateUserAction {
  FirebaseUser _user;
  String _userType;
  int _userIndex;
  FirebaseUser get user => this._user;
  String get userType => this._userType;
  int get userIndex => this._userIndex;

  UpdateUserAction(this._user, this._userType, this._userIndex);
}

ThunkAction<AppState> getFirebaseUser = (Store<AppState> store) async {
  FirebaseAuth.instance.currentUser().then((u) async {
    
    if (u == null) {
      store.dispatch(new UpdateUserAction(null, "", 1));
    } else {
      String type = await getUserType(u.uid);
      print("User is $u with type $type");
      store.dispatch(new UpdateUserAction(u, type, 1));
    }
  });
};

// Reducer
AppState reducer(AppState prev, dynamic action) {
  if (action is UpdateUserAction) {
    AppState newAppState =
        new AppState(action.user, action.userType, action.userIndex);
    return newAppState;
  } else {
    return prev;
  }
}

// store that hold our current appstate
final store = new Store<AppState>(reducer,
    initialState: new AppState(null, "", 0), middleware: [thunkMiddleware]);
