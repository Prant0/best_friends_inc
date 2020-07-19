import 'dart:convert';

import 'package:bestfriends/http/requests.dart';
import 'package:bestfriends/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FollowersScreen extends StatefulWidget {
  final int userId;
  FollowersScreen({this.userId});
  @override
  _FollowersScreenState createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  bool _init = true;
  bool isLoading = true;
  bool isFetched = false;
  List<dynamic> followers = [];
  @override
  void didChangeDependencies() async{

      if(_init)
      {
        setState(() {
          isLoading = true;
        });
        followers = await CustomHttpRequests.getFollowers(widget.userId);
       if(mounted)
         {
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
    ):isFetched&&followers.length<1?Container(
      alignment: Alignment.center,
      child: Text("No Followers"),
    ):Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListView.builder(
        itemCount: followers.length,
        itemBuilder: (context, int i){
          return ListTile(
            onTap: (){
              Navigator.of(context).pushNamed(Profile.routeName, arguments: followers[i]["id"]);
            },
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.memory(
                base64Decode(followers[i]["profile_pic"]),
                fit: BoxFit.cover,
                height: 35,
                width: 35,
              ),
            ),
            title: Text(followers[i]["name"]),
          );
        },
      ),
    );
  }
}
