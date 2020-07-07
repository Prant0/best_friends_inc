import 'dart:convert';

import 'package:bestfriends/providers/user.dart';
import 'package:bestfriends/screens/profileAbout.dart';
import 'package:bestfriends/widgets/profilePosts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  User userData;
  bool _isInit = true, _isLoading = true;
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, initialIndex: 1, vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      userData = await Provider.of<Users>(context).getUser(ModalRoute.of(context).settings.arguments);
      setState(() {
        _isLoading = false;
      });
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
                            Text(
                              userData.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
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
                        IconButton(
                          icon: Icon(Icons.person_add),
                          tooltip: 'Follow',
                          onPressed: () {},
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
                                  icon: Icon(
                                    Icons.library_books,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Tab(
                                  text: "About",
                                  icon: Icon(
                                    Icons.info,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Tab(
                                  text: "Followers",
                                  icon: Icon(
                                    Icons.group_add,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Tab(
                                  text: "Following",
                                  icon: Icon(
                                    Icons.group,
                                    color: Theme.of(context).primaryColor,
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
                    ProfileAbout(),
                    Container(
                      child: Center(
                        child: Text("Follower"),
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Text("Following"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
