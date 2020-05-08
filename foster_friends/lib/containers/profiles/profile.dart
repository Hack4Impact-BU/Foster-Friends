import 'package:flutter/material.dart';
import 'package:foster_friends/containers/authentication/login_page.dart';
import 'package:foster_friends/containers/profiles/individuals/user_profile.dart';
import 'package:foster_friends/containers/profiles/organizations/org_profile.dart';
import 'package:foster_friends/state/appState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';


class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm){
        print("In Building");
        print("BLAAA "+store.state.userType);
        switch(store.state.userType){
          case '':
            return Container(
                  child: Scaffold(
                      body: Container(
                          child: LoginPage(),
            )));
          case 'individual':
            return Container(
                    child: Scaffold(
                        body: Container(
                            child: UserProfile(),
              )));
          case 'organization':
            return Container(
                    child: Scaffold(
                        body: Container(
                            child: OrgProfile(),
              )));
        }
        
      }
    );
  }


  
}


class _ViewModel {
  final FirebaseUser user;
  final Function onLogIn;
  final int selectedIndex;

  _ViewModel({
    this.user,
    this.onLogIn,
    this.selectedIndex
  });

  static _ViewModel fromStore(Store<AppState> store){
    return new _ViewModel(
      user: store.state.user,
      selectedIndex: store.state.index,
      onLogIn: (){
        print("Hello!");
      }
    );
  }

}