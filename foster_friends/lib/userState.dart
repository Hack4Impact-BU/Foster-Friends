import 'package:redux_thunk/redux_thunk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'package:foster_friends/search.dart';

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


// Reducer
SearchStateUser reducer(SearchStateUser prev, dynamic action) {
  if (action is UpdateUserAction){
    print("User");
    SearchStateUser newAppState = 
      new SearchStateUser(action.user);
    return newAppState;
  }
  else{
    return prev;
  }
}

typedef void GenerateUser(); 