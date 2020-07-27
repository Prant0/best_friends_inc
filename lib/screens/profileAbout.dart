import 'package:bestfriends/providers/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfileAbout extends StatelessWidget {

final String petName, phone, occupation, birthday, gender, religion, livesIn, homeTown;
//final List<String> hello;
ProfileAbout({this.petName, this.phone, this.occupation, this.birthday, this.gender, this.religion, this.livesIn, this.homeTown});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> aboutData = [
      {
        "icon": FontAwesomeIcons.user,
        "label": "Known as",
        "data": petName,
      },
      {
        "icon": FontAwesomeIcons.phone,
        "label": "Dial at",
        "data": phone,
      },
      {
        "icon": FontAwesomeIcons.briefcase,
        "label": "Work as",
        "data": occupation,
      },
      {
        "icon": FontAwesomeIcons.birthdayCake,
        "label": "Birthday",
        "data": birthday,
      },
      {
        "icon": FontAwesomeIcons.venusMars,
        "label": "Gender",
        "data": gender,
      },
      {
        "icon": FontAwesomeIcons.globeAmericas,
        "label": "Follows",
        "data": religion,
      },
      {
        "icon": FontAwesomeIcons.building,
        "label": "Lives In",
        "data": livesIn,
      },
      {
        "icon": FontAwesomeIcons.home,
        "label": "Hometown",
        "data": homeTown,
      },
    ];
    return Container(
      padding: EdgeInsets.all(10),
      child: GridView.builder(
        itemCount: 8,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          crossAxisCount: 3,
        ),
        itemBuilder: (BuildContext context, index) {
          return Neumorphic(
            style: NeumorphicStyle(
              depth: 5,
              shape: NeumorphicShape.convex,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  NeumorphicIcon(
                    aboutData[index]["icon"],
                    size: 30,
                    style: NeumorphicStyle(
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  Text(
                    aboutData[index]["label"],
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(aboutData[index]["data"]==null||aboutData[index]["data"]=="null"?"----":aboutData[index]["data"], textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
