import 'package:bestfriends/providers/user.dart';
import 'package:bestfriends/screens/postStatus.dart';
import 'package:bestfriends/screens/profile.dart';
import 'package:bestfriends/screens/search.dart';
import 'package:bestfriends/screens/upcoming/bloodDonate_home.dart';
import 'package:bestfriends/screens/upcoming/ecommarce_home.dart';
import 'package:bestfriends/screens/upcoming/ecourire_home.dart';
import 'package:bestfriends/screens/updateProfile.dart';
import 'package:bestfriends/screens/wallet/walletHome.dart';
import 'package:bestfriends/widgets/allComments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import './providers/comment.dart';
import './providers/post.dart';
import './screens/singlePostDetails.dart';
import 'screens/homepage.dart';
import 'screens/login.dart';
import 'screens/registation.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Posts()),
        ChangeNotifierProvider.value(value: Comments()),
        ChangeNotifierProvider.value(value: Users()),
      ],
      child: NeumorphicApp(
        debugShowCheckedModeBanner: false,
        title: "Best Friends Inc.",
        routes: {
          HomePage.routeName: (BuildContext context) => HomePage(),
          Login_Page.routeName: (BuildContext context) => Login_Page(),
          Registation_Page.routeName: (BuildContext context) => Registation_Page(),
          SinglePostDetails.routeName: (BuildContext context) => SinglePostDetails(),
          PostStatus.routeName: (BuildContext context) => PostStatus(),
          Profile.routeName: (BuildContext context) => Profile(),
          SearchPage.routeName: (BuildContext context) => SearchPage(),
          UpdateProfile.routeName: (BuildContext context) => UpdateProfile(),
          AllComments.routeName: (BuildContext context) => AllComments(),
          WalletHome.routeName: (BuildContext context) => WalletHome(),
          EcommarceHome.routeName: (BuildContext context) => EcommarceHome(),
          BloodDonateHome.routeName: (BuildContext context) => BloodDonateHome(),
          EcourierHome.routeName: (BuildContext context) => EcourierHome(),
        },
        //(0xFF0D1C40)
        theme: NeumorphicThemeData(
            accentColor: Color(0xFF004d40),
            baseColor: Color(0xFFF4F6F9),
            textTheme: TextTheme(
                  bodyText1: TextStyle(
                    fontFamily: "Varta",
                  ),
                  subtitle1: TextStyle(
                    fontFamily: "Varta",
                  ),
                  bodyText2: TextStyle(
                    fontFamily: "Varta",
                  ),
                  subtitle2: TextStyle(
                    fontFamily: "Varta",
                  ),
              ),
            iconTheme:  IconThemeData(
                color: Color(0xFF004d40),
              //0xFF0D1C40
              ),
            ),
        home: Login_Page(),
      ),
    );
  }
}
