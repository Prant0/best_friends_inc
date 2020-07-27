import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class BloodDonateHome extends StatefulWidget {
  static const routeName = '/blood_bank_home';
  @override
  _BloodDonateHomeState createState() => _BloodDonateHomeState();
}

class _BloodDonateHomeState extends State<BloodDonateHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCD052F),
      body: InkWell(
        onTap: (){
          print("Pressed");
          showDialog(context: context,
            barrierDismissible: false,
            child: AlertDialog(
              content: Text("This feature is coming Soon"),
              title: Text("Best Friends Inc."),

              actions: <Widget>[
                NeumorphicButton(
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.concave,
                  ),
                  child: Text("Close"),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
        child: Container(
          child: Column(
            children: <Widget>[

              Container(
                margin: EdgeInsets.only(top: 25.0),
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        NeumorphicButton(
                          style: NeumorphicStyle(
                            color: Color(0xFFE2E4EA),
                            depth: -5,
                            shape: NeumorphicShape.concave,
                          ),
                          child: Center(child:FaIcon(FontAwesomeIcons.arrowLeft, color: Theme.of(context).primaryColor, size: 15,),),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                          width: 60.0,
                        ),
                        Align(
                            alignment: Alignment.topRight,
                            child: Text("Blood Bank ",style: TextStyle(color:Colors.white,fontSize: 25,fontWeight: FontWeight.w600),))



                      ],
                    ),

                    SizedBox(
                      height: 18.0,
                    ),

                    Text("Tears of mother can't save her child",style: TextStyle(fontSize: 17,color: Colors.white),),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 28.0,vertical: 20.0),
                      height: 45.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20.0),bottomStart: Radius.circular(20.0)),
                          color: Colors.white
                      ),
                      child: Center(
                        child: Text("BUT Your Blood Can",style: TextStyle(color:Color(0xFFCD052F),fontSize:20,fontWeight:FontWeight.w600,),
                    ),
                      )),

                  ],
                )
              ),

              Expanded(
                child: Container(                                          //main box
                  padding: EdgeInsets.only(top: 50.0,left: 20.0),
                  height: MediaQuery.of(context).size.height,  //-270.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),topRight: Radius.circular(40.0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      NeumorphicButton(
                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        padding: EdgeInsets.all(10),
                        onPressed: (){
                          showDialog(context: context,
                            barrierDismissible: false,
                            child: AlertDialog(
                              content: Text("This feature is coming Soon"),
                              title: Text("Best Friends Inc."),

                              actions: <Widget>[
                                NeumorphicButton(
                                  style: NeumorphicStyle(
                                    shape: NeumorphicShape.concave,
                                  ),
                                  child: Text("Close"),
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        style: NeumorphicStyle(
                          depth: 5,
                          intensity: 20,
                          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.only(bottomRight: Radius.circular(40.0),topLeft: Radius.circular(40.0))),
                        ),
                        //      splashColor: Theme.of(context).primaryColor.withOpacity(0.5),
                        //      borderRadius: BorderRadius.circular(25),
                        child: ListTile(
                          leading: Icon(FontAwesomeIcons.search, color: Color(0xFFCD002E),),
                          title: Text("Find Donor",style: TextStyle(fontSize: 22.0,color: Color(0xFF070960)),),
                        ),
                      ),
                      NeumorphicButton(
                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        padding: EdgeInsets.all(10),
                        onPressed: (){
                          showDialog(context: context,
                            barrierDismissible: false,
                            child: AlertDialog(
                              content: Text("This feature is coming Soon"),
                              title: Text("Best Friends Inc."),

                              actions: <Widget>[
                                NeumorphicButton(
                                  style: NeumorphicStyle(
                                    shape: NeumorphicShape.concave,
                                  ),
                                  child: Text("Close"),
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        style: NeumorphicStyle(
                          depth: 5,
                          intensity: 20,
                          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.only(bottomRight: Radius.circular(40.0),topLeft: Radius.circular(40.0))),
                        ),
                        //      splashColor: Theme.of(context).primaryColor.withOpacity(0.5),
                        //      borderRadius: BorderRadius.circular(25),
                        child: ListTile(
                          leading: Icon(FontAwesomeIcons.university, color: Color(0xFFCD002E),),
                          title: Text("Blood Bank",style: TextStyle(fontSize: 22.0,color: Color(0xFF070960)),),
                        ),
                      ),
                      NeumorphicButton(
                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        padding: EdgeInsets.all(10),
                        onPressed: (){
                          showDialog(context: context,
                            barrierDismissible: false,
                            child: AlertDialog(
                              content: Text("This feature is coming Soon"),
                              title: Text("Best Friends Inc."),

                              actions: <Widget>[
                                NeumorphicButton(
                                  style: NeumorphicStyle(
                                    shape: NeumorphicShape.concave,
                                  ),
                                  child: Text("Close"),
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        style: NeumorphicStyle(
                          depth: 5,
                          intensity: 20,
                          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.only(bottomRight: Radius.circular(40.0),topLeft: Radius.circular(40.0))),
                        ),
                        //      splashColor: Theme.of(context).primaryColor.withOpacity(0.5),
                        //      borderRadius: BorderRadius.circular(25),
                        child: ListTile(
                          leading: Icon(FontAwesomeIcons.plusSquare, color: Color(0xFFCD002E),),
                          title: Text("Request Blood",style: TextStyle(fontSize: 22.0,color: Color(0xFF070960)),),
                        ),
                      ),



                    ],
                  ),
                ),
              ),
            ],
            //alignment: Alignment.center,


          ),
        ),
      ),

    );
  }
}
