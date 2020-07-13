import 'package:flutter/material.dart';

class ProfileAbout extends StatelessWidget {
  final String petName, phone, occupation, birthday, gender, religion, livesIn, homeTown;
  //final List<String> hello;
  ProfileAbout({this.petName, this.phone, this.occupation, this.birthday, this.gender, this.religion, this.livesIn, this.homeTown});
  //TODO: Make it dynamic with original data
  final List<Map<String, dynamic>> aboutData = [
    {
      "icon": Icons.perm_identity,
      "label": "Known as",
      "data": "Short Name",
    },
    {
      "icon": Icons.phone_android,
      "label": "Dial at",
      "data": "+8803333333333",
    },
    {
      "icon": Icons.business_center,
      "label": "Work as",
      "data": "C.E.O",
    },
    {
      "icon": Icons.calendar_today,
      "label": "Birthday",
      "data": "1st January, 1990",
    },
    {
      "icon": Icons.accessibility,
      "label": "Gender",
      "data": "Male",
    },
    {
      "icon": Icons.language,
      "label": "Follows",
      "data": "Islam",
    },
    {
      "icon": Icons.location_city,
      "label": "Lives In",
      "data": "Dhaka",
    },
    {
      "icon": Icons.home,
      "label": "Hometown",
      "data": "Dhaka",
    },
  ];
  @override
  Widget build(BuildContext context) {
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
                  Text(aboutData[index]["data"]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
