import 'package:redux_thunk/redux_thunk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'package:foster_friends/search.dart';

// AppState
class UserState {
  FirebaseUser _user;
  String _userType;

  FirebaseUser get user => _user;
  String get userType => _userType;

  UserState(this._user, this._userType);
}


class UpdateUserAction{
  FirebaseUser _user;
  String _userType;
  FirebaseUser get user => this._user;
  String get userType => this._userType;

  UpdateUserAction(this._user, this._userType);
}


// Reducer
SearchStateUser reducer(SearchStateUser prev, dynamic action) {
  if (action is UpdateUserAction){
    print("User");
    SearchStateUser newAppState = 
      new SearchStateUser(action.user, action.userType);
    return newAppState;
  }
  else{
    return prev;
  }
}

typedef void GenerateUser(); 