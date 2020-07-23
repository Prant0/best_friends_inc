import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';


class PersonalDrawerItem extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Function onTap;
  PersonalDrawerItem({this.iconData,this.text,this.onTap});
  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: EdgeInsets.all(0),
      onPressed: onTap,
        style: NeumorphicStyle(
          depth: 5,
          intensity: 20,
          boxShape: NeumorphicBoxShape.stadium(),
        ),
//      splashColor: Theme.of(context).primaryColor.withOpacity(0.5),
//      borderRadius: BorderRadius.circular(25),
        child: ListTile(
        leading: Icon(iconData),
        title: Text(text),
      ),
    );
  }
}