import 'package:redux_thunk/redux_thunk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';

// AppState
class AppState {
  FirebaseUser _user;

  FirebaseUser get user => _user;

  AppState(this._user);
}

class UpdateUserAction{
  FirebaseUser _user;
  FirebaseUser get user => this._user;

  UpdateUserAction(this._user);
}

ThunkAction<AppState> getFirebaseUser = (Store<AppState> store) async{
  FirebaseAuth.instance.currentUser().then((u){
    print("getting user");
    print("User is $u");
    store.dispatch(new UpdateUserAction(u));
  });
};

// Reducer
AppState reducer(AppState prev, dynamic action) {
  if (action is UpdateUserAction){
    print("User is $action.user");
    AppState newAppState = 
      new AppState(action.user);
    return newAppState;
  }
  else{
    return prev;
  }
}

// store that hold our current appstate
final store = new Store<AppState>(reducer,
    initialState: new AppState(null), middleware: [thunkMiddleware]);
