import 'package:flutter/material.dart';

class SinglePostDetailsFAB extends StatelessWidget {
  final String counts;
  final Function press;
  final IconData iconData;
  SinglePostDetailsFAB({this.counts,this.iconData,this.press});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 50,
      child: FloatingActionButton(
        heroTag: null,
        onPressed: press,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal:5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Icon(iconData, color: Theme.of(context).primaryColor,),
              ),
              Expanded(
                child: Text('$counts', style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),),
              )
            ],
          ),
        ),
        ),
      );
  }
}