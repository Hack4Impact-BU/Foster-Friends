import 'package:redux_thunk/redux_thunk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'package:foster_friends/containers/search.dart';

// AppState
class UserState {
  FirebaseUser _user;
  String _userType;
  int _userIndex;

  FirebaseUser get user => _user;
  String get userType => _userType;
  int get userIndex => _userIndex;

  UserState(this._user, this._userType);
}


class UpdateUserAction{
  FirebaseUser _user;
  String _userType;
  int _userIndex;
  FirebaseUser get user => this._user;
  String get userType => this._userType;
  int get userIndex => this._userIndex;

  UpdateUserAction(this._user, this._userType, this._userIndex);
}


// Reducer
SearchStateUser reducer(SearchStateUser prev, dynamic action) {
  if (action is UpdateUserAction){
    print("User");
    SearchStateUser newAppState = 
      new SearchStateUser(action.user, action.userType, action.userIndex);
    return newAppState;
  }
  else{
    return prev;
  }
}

typedef void GenerateUser(); 