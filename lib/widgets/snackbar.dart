import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final BuildContext context;
  final String message;
  CustomSnackBar({this.context, this.message});
  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    return Builder(
      //builder: (context)=>Scaffold.of(context).showSnackBar(snackBar),
    );
  }
}
