import '../widgets/personalDrwaerItems.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical:50, horizontal:20),
              child: Column(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.asset('images/bf.png'),
                      ),
                      Text('Your Name', style: TextStyle(
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
                    PersonalDrawerItem(iconData: Icons.face, text: 'My Profile', onTap: (){},),
                    PersonalDrawerItem(iconData: Icons.timeline, text: 'Timeline', onTap: (){},),
                    PersonalDrawerItem(iconData: Icons.account_balance_wallet, text: 'E-Wallet', onTap: (){},),
                    PersonalDrawerItem(iconData: Icons.photo, text: 'My Albums', onTap: (){},),
                    PersonalDrawerItem(iconData: Icons.book, text: 'My Pages', onTap: (){},),
                    PersonalDrawerItem(iconData: Icons.group, text: 'My Groups', onTap: (){},),
                    PersonalDrawerItem(iconData: Icons.calendar_today, text: 'My Events', onTap: (){},),
                    PersonalDrawerItem(iconData: Icons.lock_open, text: 'Complete Verification', onTap: (){},),
                    PersonalDrawerItem(iconData: Icons.settings, text: 'Settings', onTap: (){},),
                    PersonalDrawerItem(iconData: Icons.exit_to_app, text: 'Logout', onTap: (){},),
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
