import 'package:bestfriends/screens/postStatus.dart';
import 'package:bestfriends/screens/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './providers/comment.dart';
import './providers/post.dart';
import './screens/singlePostDetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/homepage.dart';
import 'screens/login.dart';
import 'screens/registation.dart';

void main()=>runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context){
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Posts()),
        ChangeNotifierProvider.value(value: Comments()),
      ],
        child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Find Friendz",
        routes: {
          HomePage.routeName: (BuildContext context)=>HomePage(),
          Login_Page.routeName:(BuildContext context)=>Login_Page(),
          Registation_Page.routeName:(BuildContext context)=>Registation_Page(),
          SinglePostDetails.routeName: (BuildContext context)=>SinglePostDetails(),
          PostStatus.routeName: (BuildContext context)=>PostStatus(),
          Profile.routeName: (BuildContext context)=>Profile(),
        },
        theme: ThemeData(
            primaryColor: Colors.teal,
            accentColor: Colors.deepOrangeAccent,
            textTheme: TextTheme(
              headline: TextStyle(fontSize: 60.0,fontWeight: FontWeight.bold,color: Colors.teal),
              title: TextStyle(fontSize: 35,),
             // body1: TextStyle(fontSize: 18.0,color: Colors.teal),
            )
        ),
        home: Login_Page(),
      ),
    );
  }

}
