import 'dart:convert';

import 'package:bestfriends/http/requests.dart';
import 'package:bestfriends/providers/user.dart';
import 'package:bestfriends/screens/followers.dart';
import 'package:bestfriends/screens/followings.dart';
import 'package:bestfriends/screens/profileAbout.dart';
import 'package:bestfriends/screens/updateProfile.dart';
import 'package:bestfriends/widgets/profilePosts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  User userData;
  bool _isInit = true, _isLoading = true;
  TabController _tabController;
  SharedPreferences sharedPreferences;
  bool following = false;

  @override
  void initState() {

    _tabController = TabController(length: 4, initialIndex: 1, vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      userData = await Provider.of<Users>(context).getUser(ModalRoute.of(context).settings.arguments);
      sharedPreferences = await SharedPreferences.getInstance();
      if(mounted)
        {
          setState(() {
            following = userData.isFollowedByMe;
            _isLoading = false;
          });
        }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading == true
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : DefaultTabController(
              length: 4,
              initialIndex: 1,
              child: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      backgroundColor: Theme.of(context).primaryColor,
                      expandedHeight: 200.0,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.memory(
                                base64.decode(userData.profilePic),
                                fit: BoxFit.cover,
                                height: 35,
                                width: 35,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            NeumorphicText(
                              userData.name,
                              style: NeumorphicStyle(
                                color: Color(0xffF5F6FD),
                              ),
                              textStyle: NeumorphicTextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        background: Stack(
                          children: <Widget>[
                            Container(
                                height: double.infinity,
                                width: double.infinity,
                                child: Image.memory(
                                  base64.decode(userData.coverPic),
                                  fit: BoxFit.cover,
                                )),
                            Container(
                              width: double.infinity,
                              color: Colors.black45,
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        ModalRoute.of(context).settings.arguments==int.parse(sharedPreferences.getString("userId"))?
                           IconButton(
                             icon: Icon(FontAwesomeIcons.edit,),
                             tooltip: 'Update Info',
                             onPressed: () {
                               Navigator.of(context).pushNamed(UpdateProfile.routeName);
                             },
                           ): following?IconButton(
                  icon: Icon(FontAwesomeIcons.userTimes),
                  tooltip: 'Un-follow',
                  onPressed: () async{
                  final data = await CustomHttpRequests.followUser(userData.userId);
                  if(data["detached"].length>0){
                    setState(() {
                      following = false;
                    });
                  }
                  },
                  ) :IconButton(
                          icon: Icon(FontAwesomeIcons.userPlus),
                          tooltip: 'Follow',
                          onPressed: () async{
                              final data = await CustomHttpRequests.followUser(userData.userId);
                              if(data["attached"].length>0){
                                setState(() {
                                  following = true;
                                });
                              }
                          },
                        ),
                      ],
                    ),
                    SliverPadding(
                      padding: EdgeInsets.all(15),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            TabBar(
                              controller: _tabController,
                              labelColor: Colors.black,
                              isScrollable: true,
                              unselectedLabelColor: Colors.grey,
                              labelPadding: EdgeInsets.symmetric(horizontal: 25),
                              indicatorColor: Theme.of(context).primaryColor,
                              tabs: [
                                Tab(
                                  text: "Posts",
                                  icon: NeumorphicIcon(
                                    Icons.library_books,
                                    size: 30,
                                    style: NeumorphicStyle(
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                  ),
                                ),
                                Tab(
                                  text: "About",
                                  icon: NeumorphicIcon(
                                    Icons.info,
                                    size: 30,
                                    style: NeumorphicStyle(
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                  ),
                                ),
                                Tab(
                                  text: "Followers",
                                  icon: NeumorphicIcon(
                                    Icons.group_add,
                                    size: 30,
                                    style: NeumorphicStyle(
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                  ),
                                ),
                                Tab(
                                  text: "Followings",
                                  icon: NeumorphicIcon(
                                    Icons.group,
                                    size: 30,
                                    style: NeumorphicStyle(
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    ProfilePosts(),
                    ProfileAbout(
                      petName: userData.nickName,
                      phone: userData.phone,
                      occupation: userData.occupation,
                      birthday: userData.birthday,
                      gender: userData.gender,
                      religion: userData.religion,
                      livesIn: userData.livesIn,
                      homeTown: userData.hometown,
                    ),
                    FollowersScreen(userId: userData.userId,),
                    FollowingScreen(userId: userData.userId,),
                  ],
                ),
              ),
            ),
    );
  }
}
