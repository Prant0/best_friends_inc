import 'dart:convert';

import 'package:bestfriends/http/requests.dart';
import 'package:bestfriends/screens/homepage.dart';
import 'package:bestfriends/screens/login.dart';
import 'package:bestfriends/screens/profile.dart';
import 'package:bestfriends/screens/search.dart';
import 'package:bestfriends/screens/wallet/walletHome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/personalDrwaerItems.dart';

class CustomDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> sKey;
  CustomDrawer(this.sKey);
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  SharedPreferences sharedPreferences;
  bool _isInit = true;


  @override
  void didChangeDependencies() async {
    if (_isInit) {
      sharedPreferences = await SharedPreferences.getInstance();
      setState(() {
        _isInit = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  removeToken(BuildContext context) async {
    await CustomHttpRequests.logout();
    sharedPreferences.remove("userId");
    sharedPreferences.remove("name");
    sharedPreferences.remove("profile_pic");
    sharedPreferences.remove("token");
    Navigator.of(context).pushNamedAndRemoveUntil(Login_Page.routeName, (route) => false);
  }

  showSnack(){
    Navigator.of(context).pop();
    widget.sKey.currentState.removeCurrentSnackBar();
    widget.sKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.blueGrey,
        content: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Coming Soon...",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          color: Color(0xffF5F6FD),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: Column(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: sharedPreferences==null?Container():Image.memory(base64Decode(sharedPreferences.getString("profile_pic")),width: 100, height: 100, fit: BoxFit.cover,),
                      ),
                      Text(
                        sharedPreferences==null?"Best Friends Inc.":sharedPreferences.getString("name"),
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Expanded(
                  //height: MediaQuery.of(context).size.height*0.7,
                  child: ListView(
                    children: <Widget>[
                      PersonalDrawerItem(
                        iconData: Icons.face,
                        text: 'My Profile',
                        onTap: () async{
                          Navigator.of(context).pushNamed(Profile.routeName, arguments: int.parse(sharedPreferences.getString("userId")));
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: Icons.search,
                        text: 'Search User',
                        onTap: () {
                          Navigator.of(context).pushNamed(SearchPage.routeName);
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: Icons.account_balance_wallet,
                        text: 'E-Wallet',
                        onTap: () {
                          Navigator.of(context).pushNamed(WalletHome.routeName);
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: Icons.photo,
                        text: 'My Albums',
                        onTap: () {
                          showSnack();
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: Icons.book,
                        text: 'My Pages',
                        onTap: () {
                          showSnack();
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: Icons.group,
                        text: 'My Groups',
                        onTap: () {
                          showSnack();
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: Icons.calendar_today,
                        text: 'My Events',
                        onTap: () {
                          showSnack();
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: Icons.lock_open,
                        text: 'Complete Verification',
                        onTap: () {
                          showSnack();
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: Icons.settings,
                        text: 'Settings',
                        onTap: () {
                          showSnack();
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: Icons.exit_to_app,
                        text: 'Logout',
                        onTap: () {
                          removeToken(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
