import 'package:bestfriends/http/requests.dart';
import 'package:bestfriends/screens/login.dart';
import 'package:bestfriends/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/personalDrwaerItems.dart';

class CustomDrawer extends StatelessWidget {
  SharedPreferences sharedPreferences;
  removeToken(BuildContext context) async {
    sharedPreferences = await SharedPreferences.getInstance();
    await CustomHttpRequests.logout();
    sharedPreferences.clear();
    Navigator.of(context).pushNamedAndRemoveUntil(Login_Page.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Column(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Image.asset('images/bf.png'),
                    ),
                    Text(
                      'Your Name',
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
                      onTap: () {
                        //TODO: Include Navigation to profile with current user profile ID which should be stored in Shared Preferences
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
                      iconData: Icons.timeline,
                      text: 'Timeline',
                      onTap: () {},
                    ),
                    PersonalDrawerItem(
                      iconData: Icons.account_balance_wallet,
                      text: 'E-Wallet',
                      onTap: () {},
                    ),
                    PersonalDrawerItem(
                      iconData: Icons.photo,
                      text: 'My Albums',
                      onTap: () {},
                    ),
                    PersonalDrawerItem(
                      iconData: Icons.book,
                      text: 'My Pages',
                      onTap: () {},
                    ),
                    PersonalDrawerItem(
                      iconData: Icons.group,
                      text: 'My Groups',
                      onTap: () {},
                    ),
                    PersonalDrawerItem(
                      iconData: Icons.calendar_today,
                      text: 'My Events',
                      onTap: () {},
                    ),
                    PersonalDrawerItem(
                      iconData: Icons.lock_open,
                      text: 'Complete Verification',
                      onTap: () {},
                    ),
                    PersonalDrawerItem(
                      iconData: Icons.settings,
                      text: 'Settings',
                      onTap: () {},
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
    );
  }
}
