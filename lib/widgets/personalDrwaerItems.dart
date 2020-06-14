import 'package:flutter/material.dart';


class PersonalDrawerItem extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Function onTap;
  PersonalDrawerItem({this.iconData,this.text,this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Theme.of(context).primaryColor.withOpacity(0.5),
      borderRadius: BorderRadius.circular(25),
        child: ListTile(
        leading: Icon(iconData),
        title: Text(text),
      ),
    );
  }
}