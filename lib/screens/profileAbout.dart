import 'package:bestfriends/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileAbout extends StatelessWidget {

final String petName, phone, occupation, birthday, gender, religion, livesIn, homeTown;
//final List<String> hello;
ProfileAbout({this.petName, this.phone, this.occupation, this.birthday, this.gender, this.religion, this.livesIn, this.homeTown});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> aboutData = [
      {
        "icon": Icons.perm_identity,
        "label": "Known as",
        "data": petName,
      },
      {
        "icon": Icons.phone_android,
        "label": "Dial at",
        "data": phone,
      },
      {
        "icon": Icons.business_center,
        "label": "Work as",
        "data": occupation,
      },
      {
        "icon": Icons.calendar_today,
        "label": "Birthday",
        "data": birthday,
      },
      {
        "icon": Icons.accessibility,
        "label": "Gender",
        "data": gender,
      },
      {
        "icon": Icons.language,
        "label": "Follows",
        "data": religion,
      },
      {
        "icon": Icons.location_city,
        "label": "Lives In",
        "data": livesIn,
      },
      {
        "icon": Icons.home,
        "label": "Hometown",
        "data": homeTown,
      },
    ];
    return Container(
      padding: EdgeInsets.all(10),
      child: GridView.builder(
        itemCount: 8,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: 2,
        ),
        itemBuilder: (BuildContext context, index) {
          return Card(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    aboutData[index]["icon"],
                    size: 35,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    aboutData[index]["label"],
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(aboutData[index]["data"]==null?"----":aboutData[index]["data"]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
