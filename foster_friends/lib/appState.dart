import 'package:redux_thunk/redux_thunk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'package:foster_friends/database.dart';

// AppState
class AppState {
  FirebaseUser _user;
  String _userType;

  FirebaseUser get user => _user;
  String get userType => this._userType;

  AppState(this._user, this._userType);
}

class UpdateUserAction{
  FirebaseUser _user;
  String _userType;
  FirebaseUser get user => this._user;
  String get userType => this._userType;

  UpdateUserAction(this._user, this._userType);
}

ThunkAction<AppState> getFirebaseUser = (Store<AppState> store) async{
  FirebaseAuth.instance.currentUser().then((u) async {
    
    String type = await getUserType(u.uid);
    print("User is $u with type $type");
    store.dispatch(new UpdateUserAction(u, type));    
  });
};

// Reducer
AppState reducer(AppState prev, dynamic action) {
  if (action is UpdateUserAction){
    AppState newAppState = 
      new AppState(action.user, action.userType);
    return newAppState;
  }
  else{
    return prev;
  }
}

// store that hold our current appstate
final store = new Store<AppState>(reducer,
    initialState: new AppState(null, ""), middleware: [thunkMiddleware]);
