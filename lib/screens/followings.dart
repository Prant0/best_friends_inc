import 'dart:convert';

import 'package:bestfriends/http/requests.dart';
import 'package:bestfriends/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class FollowingScreen extends StatefulWidget {
  final int userId;
  FollowingScreen({this.userId});
  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  bool _init = true;
  bool isLoading = true;
  bool isFetched = false;
  List<dynamic> followings = [];
  @override
  void didChangeDependencies() async{
    if(mounted)
      {
        if(_init)
        {
          setState(() {
            isLoading = true;
          });
          followings = await CustomHttpRequests.getFollowings(widget.userId);
          setState(() {
            isLoading = false;
            isFetched = true;
            _init = false;
          });
        }
      }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading?Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    ):isFetched&&followings.length<1?Container(
      alignment: Alignment.center,
      child: Text("No Followings"),
    ):Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListView.builder(
        itemCount: followings.length,
        itemBuilder: (context, int i){
          return Neumorphic(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            style: NeumorphicStyle(
              shape: NeumorphicShape.convex,
              intensity: 20,
            ),
            child: ListTile(
              onTap: (){
                Navigator.of(context).pushNamed(Profile.routeName, arguments: followings[i]["id"]);
              },
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.memory(
                  base64Decode(followings[i]["profile_pic"]),
                  fit: BoxFit.cover,
                  height: 35,
                  width: 35,
                ),
              ),
              title: Text(followings[i]["name"]),
            ),
          );
        },
      ),
    );
  }
}
