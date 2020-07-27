import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WalletHome extends StatefulWidget {
  static const String routeName = "/WalletHomePage";
  @override
  _WalletHomeState createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF244F9D),
//      appBar: NeumorphicAppBar(
//        title: NeumorphicText("E-Wallet", style: NeumorphicStyle(color: Theme.of(context).primaryColor,),),
//        centerTitle: true,
//      ),
      body: Neumorphic(
        style: NeumorphicStyle(
          color: Color(0xFF244F9D),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  color: Color(0xFF244F9D),
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("\$2,589.90", style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                              ),
                              Text("Available Balance", style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.bell, color: Colors.white,),
                            onPressed: (){},
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        //TODO: Optimize Button Codes
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              NeumorphicButton(
                                style: NeumorphicStyle(
                                  shape: NeumorphicShape.convex,
                                  depth: 0,
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.creditCard
                                ),
                                onPressed: (){},
                              ),
                              SizedBox(height: 10,),
                              Text("Withdraw", style: TextStyle(
                                color: Color(0xFFF2F4F7),
                                fontSize: 18,
                              ),),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              NeumorphicButton(
                                style: NeumorphicStyle(
                                  shape: NeumorphicShape.convex,
                                  depth: 0,
                                ),
                                child: FaIcon(
                                    FontAwesomeIcons.paperPlane
                                ),
                                onPressed: (){},
                              ),
                              SizedBox(height: 10,),
                              Text("Send", style: TextStyle(
                                color: Color(0xFFF2F4F7),
                                fontSize: 18,
                              ),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Recent Transaction", style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            NeumorphicButton(
                              onPressed: (){},
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.convex,
                                intensity: 0,
                              ),
                              child: Text("See all", style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15,
                              ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: Container(
                            width: 150,
                            height: 150,
                            child: NeumorphicButton(
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.convex,
                                boxShape: NeumorphicBoxShape.circle(),
                                intensity: 1,
                                surfaceIntensity: 0.7,
                              ),
                              onPressed: (){},
                              child: Center(child: Text("Under Construction", textAlign: TextAlign.center,)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
