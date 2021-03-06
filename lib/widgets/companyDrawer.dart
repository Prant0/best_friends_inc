import 'dart:convert';

import 'package:bestfriends/http/requests.dart';
import 'package:bestfriends/screens/login.dart';
import 'package:bestfriends/screens/profile.dart';
import 'package:bestfriends/screens/search.dart';
import 'package:bestfriends/screens/upcoming/bloodDonate_home.dart';
import 'package:bestfriends/screens/upcoming/ecommarce_home.dart';
import 'package:bestfriends/screens/upcoming/ecourire_home.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/personalDrwaerItems.dart';

class CompanyDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> sKey;
  CompanyDrawer(this.sKey);
  @override
  _CompanyDrawerState createState() => _CompanyDrawerState();
}

class _CompanyDrawerState extends State<CompanyDrawer> {
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
    sharedPreferences.clear();
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
                        child: Image.asset("images/bf.png", height: 100, width: 100, fit: BoxFit.cover,),
                      ),
                      Text(
                        "Best Friends Inc.",
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
                        iconData: Icons.shopping_cart,
                        text: 'E-commerce',
                        onTap: (){
                          Navigator.of(context).pushNamed(EcommarceHome.routeName);
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: Icons.pin_drop,
                        text: 'Blood Bank',
                        onTap: () {
                          Navigator.of(context).pushNamed(BloodDonateHome.routeName);
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: Icons.card_giftcard,
                        text: 'E-courier',
                        onTap: () {
                          Navigator.of(context).pushNamed(EcourierHome.routeName);
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: Icons.directions_car,
                        text: 'Ride Sharing',
                        onTap: () {
                          showSnack();
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: Icons.laptop_chromebook,
                        text: 'E-learning School',
                        onTap: () {
                          showSnack();
                        },
                      ),

                      PersonalDrawerItem(
                        iconData: FontAwesomeIcons.hamburger,
                        text: 'B-Food',
                        onTap: (){
                          showSnack();
                        },
                      ),

                      PersonalDrawerItem(
                        iconData: FontAwesomeIcons.gift,
                        text: 'B-Courier',
                        onTap: (){
                          showSnack();
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: FontAwesomeIcons.ccVisa,
                        text: 'B-Pay',
                        onTap: (){
                          showSnack();
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: FontAwesomeIcons.idCard,
                        text: 'B-Card Service',
                        onTap: (){
                          showSnack();
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: FontAwesomeIcons.penSquare,
                        text: 'Live Tutor / Tuition',
                        onTap: (){
                          showSnack();
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: FontAwesomeIcons.bell,
                        text: 'All types of alert',
                        onTap: (){
                          showSnack();
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: FontAwesomeIcons.moneyCheckAlt,
                        text: 'Charity',
                        onTap: (){
                          showSnack();
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: FontAwesomeIcons.stethoscope,
                        text: 'B-Doctor',
                        onTap: (){
                          showSnack();
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: FontAwesomeIcons.cube,
                        text: 'B-Quizzes',
                        onTap: (){
                          showSnack();
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: FontAwesomeIcons.puzzlePiece,
                        text: 'B-Puzzle',
                        onTap: (){
                          showSnack();
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: FontAwesomeIcons.gamepad,
                        text: 'B-Games',
                        onTap: (){
                          showSnack();
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: FontAwesomeIcons.users,
                        text: 'Freelancing Marketplace',
                        onTap: (){
                          showSnack();
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: FontAwesomeIcons.briefcase,
                        text: 'Career Finder',
                        onTap: (){
                          showSnack();
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: FontAwesomeIcons.newspaper,
                        text: 'B-News Portal',
                        onTap: (){
                          showSnack();
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: FontAwesomeIcons.shoppingBasket,
                        text: 'B-Baazar',
                        onTap: (){
                          showSnack();
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: FontAwesomeIcons.book,
                        text: 'Reading and Reviews',
                        onTap: (){
                          showSnack();
                        },
                      ),
                      PersonalDrawerItem(
                        iconData: FontAwesomeIcons.ccAmex,
                        text: 'Earning Opportunities',
                        onTap: (){
                          showSnack();
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
