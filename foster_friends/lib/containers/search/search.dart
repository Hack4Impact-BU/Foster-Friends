import 'package:flutter/material.dart';
import 'package:foster_friends/containers/search/searchForm.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Container(
    //     child: SearchState(),
    //     padding: EdgeInsets.all(10),
    //     color: Colors.white,
    // );
    return Dialog(
      insetPadding: EdgeInsets.all(10),
      child: SingleChildScrollView(child: SearchForm()),
    );
  }
}
