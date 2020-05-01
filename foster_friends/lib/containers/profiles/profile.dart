import 'package:flutter/material.dart';
import 'package:foster_friends/containers/authentication/no_signin.dart';
import 'package:foster_friends/containers/profiles/individuals/user_profile.dart';
import 'package:foster_friends/containers/profiles/organizations/org_profile.dart';
import 'package:foster_friends/state/appState.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  
    switch(store.state.userType){
      case 'Individual':
        return UserProfile();
      case 'Organization':
        return OrgProfile();
      default:
        return NoSignIn();
    }

  }
}