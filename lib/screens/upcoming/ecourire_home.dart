import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EcourierHome extends StatefulWidget {
  static const routeName = '/courier';
  @override
  _EcourierHomeState createState() => _EcourierHomeState();
}

class _EcourierHomeState extends State<EcourierHome> with SingleTickerProviderStateMixin{
   TabController tabController;
  @override
  void initState() {
    tabController = TabController( length:  2, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
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
                              width: 70.0,
                            ),
                            Align(
                                alignment: Alignment.topRight,
                                child: Text("E-courier ",style: TextStyle(color:Colors.white,fontSize:30,fontWeight: FontWeight.w600),))
                          ],
                        ),

                        SizedBox(height:30.0),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                           Column(
                             children: <Widget>[
                               NeumorphicButton(
                                 style: NeumorphicStyle(
                                   color: Colors.white,
                                   depth: -20,
                                   intensity: 10,
                                   shape: NeumorphicShape.concave,
                                 ),
                                 child: Center(child:FaIcon(FontAwesomeIcons.paperPlane, color: Theme.of(context).primaryColor, size: 35,),),
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
                               ),
                               SizedBox(
                                 height: 7.0,
                               ),
                               Text("Send",style: TextStyle(color: Colors.white,fontSize: 20),)
                             ],
                           ),
                            Column(
                              children: <Widget>[
                                NeumorphicButton(
                                  style: NeumorphicStyle(
                                    color: Colors.white,
                                    depth: -20,
                                    intensity: 10,
                                    shape: NeumorphicShape.concave,
                                  ),
                                  child: Center(child:FaIcon(FontAwesomeIcons.arrowCircleDown,
                                    color: Theme.of(context).primaryColor, size: 35,),),
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
                                ),
                                SizedBox(
                                  height: 7.0,
                                ),
                                Text("Delivery",style: TextStyle(color: Colors.white,fontSize: 20),)
                              ],
                            ),

                          ],
                        )

                      ],
                    )
                ),

                              Expanded(
                                child: Container(
                                  width:MediaQuery.of(context).size.width,//main box
                                  padding: EdgeInsets.only(top: 10.0,),
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
                                      Text("My Ecourier info",style: TextStyle(fontSize: 25.0,color: Colors.teal,),),
                                      SizedBox(
                                        height: 12.0,
                                      ),

                                      Padding(
                                        padding: EdgeInsets.only(left: 25),
                                        child: TabBar(
                                          isScrollable: false,
                                          unselectedLabelColor: Colors.black,
                                          indicator: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50.0),
                                            color: Colors.teal
                                          ),
                                          controller: tabController,
                                          tabs: <Widget>[
                                            Tab(child: Container(
                                              width: 150,//1st tab
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50.0),
                                                border: Border.all(color: Colors.teal,width: 1),
                                              ),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text("Send info"),
                                              ),
                                            ),),


                                            Tab(child: Container(
                                              width: 150,//2nd Tab
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50.0),
                                                border: Border.all(color: Colors.teal,width: 1),
                                              ),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text("Delevery info"),
                                              ),
                                            ),),
                                          ],),
                                      ),

                                      Container(
                                        height: 300,
                                        width: 300,
                                        child: TabBarView(
                                          controller: tabController,
                                          children: <Widget>[
                                            Container(               ///   1st   tab item
                                              child: Center(
                                                child: Text(
                                                  "Coming Soon",style: TextStyle(fontSize: 30.0),
                                                ),
                                              ),
                                            ),
                                            Container(               ///   2nd  tab item
                                              child: Center(
                                                child: Text(
                                                    "Coming Soon",style: TextStyle(fontSize: 30.0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),



                              ],
                            ),
                          ),
                        ),

              ],
          ),
        ),
      ),

    );
  }
}
