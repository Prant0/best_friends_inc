import 'dart:convert';

import 'package:bestfriends/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class SingleResult extends StatelessWidget {
  final int userId;
  final String userName;
  final bool userIsVerified;
  final String userProfilePic;
  SingleResult({this.userId, this.userIsVerified, this.userName, this.userProfilePic});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(Profile.routeName, arguments: userId);
      },
      child: Neumorphic(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        style: NeumorphicStyle(
          shape: NeumorphicShape.convex,
          intensity: 20,
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.memory(
              base64Decode(userProfilePic),
              fit: BoxFit.cover,
              height: 35,
              width: 35,
            ),
          ),
          title: Text(userName),
          subtitle: userIsVerified ? Text("Verified User") : null,
        ),
      ),
    );
  }
}
