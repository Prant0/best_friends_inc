import 'package:flutter/material.dart';

class SinglePostDetailsFAB extends StatelessWidget {
  final int counts;
  final Function press;
  final IconData iconData;
  SinglePostDetailsFAB({this.counts,this.iconData,this.press});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 30,
      child: FloatingActionButton(
        heroTag: null,
        onPressed: press,
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal:5),
            child: Row(
            children: [
              Expanded(
                child: Icon(iconData),
              ),
              Expanded(
                child: Text('$counts'),
              )
            ],
          ),
        ),
        ),
      );
  }
}