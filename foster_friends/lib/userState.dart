import 'package:redux_thunk/redux_thunk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';

// AppState
class UserState {
  FirebaseUser _user;

  FirebaseUser get user => _user;

  UserState(this._user);
}


class UpdateUserAction{
  FirebaseUser _user;
  FirebaseUser get user => this._user;

  UpdateUserAction(this._user);
}



ThunkAction<UserState> getFirebaseUser = (Store<UserState> store) async{
  FirebaseAuth.instance.currentUser().then((u){
    print("getting user");
    print("User is $u");
    store.dispatch(new UpdateUserAction(u));
  });
};

// Reducer
UserState reducer(UserState prev, dynamic action) {
  if (action is UpdateUserAction){
    print("User");
    UserState newAppState = 
      new UserState(action.user);
    return newAppState;
  }
  else{
    return prev;
  }
}

// store that hold our current appstate
final store = new Store<UserState>(reducer,
    initialState: new UserState(null), middleware: [thunkMiddleware]);


typedef void GenerateUser(); 