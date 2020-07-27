import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EcommarceHome extends StatefulWidget {
  static const routeName = '/ecommerce';
  @override
  _EcommarceHomeState createState() => _EcommarceHomeState();
}

class _EcommarceHomeState extends State<EcommarceHome> {
  List<String> imgUrls = ["https://cdn.pixabay.com/photo/2016/06/06/21/41/a-slim-body-1440502_960_720.jpg",
    "https://cdn.idntimes.com/content-images/community/2019/07/pexels-photo-1964970-a4d0d9ed1eb27eba89daef893c80f281.jpeg",
  "https://www.maxpixel.net/static/photo/1x/Iphone-Iphone-X-Smartphone-Apple-X-Mobile-3503673.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/b/b4/Supermarket_z_flagami_%28ubt%29.JPG"];
    List<String> category=["https://p1.pxfuel.com/preview/540/504/889/rolex-watch-watches-luxury-watch-wristwatch-class.jpg",
        "https://p1.pxfuel.com/preview/710/644/972/red-heels-shoes-table-crown-fashion.jpg",
          "https://cdn.pixabay.com/photo/2018/10/29/15/27/laptop-3781380_960_720.jpg",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSYDgfkwTsy2htdD9Tj1eNI3sxptJoPyPZ9NA&usqp=CAU"
    ];

  List<String> name = ["Women" , "Men" , "Gadget","Grocery"];
  List<String> hotProducts = ["Watch ", "Women" , "Laptop" ,"Belt"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE2E4EA),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                height:150.0,
                width: 35.0,
                child: Stack(
                  children: <Widget>[
                    IconButton(
                      onPressed: (){},
                      iconSize: 35.0,
                      icon: Icon(Icons.shopping_cart,color: Colors.black87,),
                    ),
                    Positioned(
                      // bottom: 5.0,
                      child: Stack(
                        children: <Widget>[
                          Icon(Icons.brightness_1,size: 27.0,color: Colors.red,),
                          Positioned(
                            top: 5.0,
                            right: 9.0,
                            child: Center(child: Text('0'),),
                          )
                        ],
                      ),
                    )
                  ],
                )
            ),
          )
        ],
        leading: NeumorphicButton(
          style: NeumorphicStyle(
            color: Color(0xFFE2E4EA),
            depth: 5,
            shape: NeumorphicShape.concave,
          ),
          child: Center(child:FaIcon(FontAwesomeIcons.arrowLeft, color: Theme.of(context).primaryColor, size: 15,),),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        title: Center(child: NeumorphicText("Ecommerce",style: NeumorphicStyle(color: Theme.of(context).primaryColor,), textStyle: NeumorphicTextStyle(fontSize: 20),)),
      ),

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
          child: ListView(
            children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: SizedBox(
              height: 210.0,
              width: MediaQuery.of(context).size.width,
              child: Carousel(
                boxFit: BoxFit.cover,
                images: imgUrls.map((e) => Image.network(e, fit: BoxFit.cover,)).toList(),
                animationCurve: Curves.fastOutSlowIn,
                animationDuration: Duration(milliseconds: 1000),
              ),
          ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Product Category :",style:TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600),),
            ),
             Container(
               height: 200.0,
               child: ListView.builder(
                 scrollDirection: Axis.horizontal,
                 physics: BouncingScrollPhysics(),
                 itemCount: imgUrls.length,
                 itemBuilder: (context,index){
                   return
                     Container(
                       height: 180.0,
                       width: 150.0,
                       child: Card(
                         child: Column(
                           children: <Widget>[
                             Image.network(
                               imgUrls[index],
                               height: 150.0,
                               width: 150.0,
                               fit: BoxFit.cover,),
                             Padding(
                               padding: EdgeInsets.all(8.0),
                               child: Text(name[index]),
                             )
                           ],
                         ),
                       ),
                     );

                 },
               ),
             ),

              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("Hot Products :",style:TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600),),
              ),
              Container(
                height: 200.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: imgUrls.length,
                  itemBuilder: (context,index){
                    return
                      Container(
                        height: 180.0,
                        width: 150.0,
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Image.network(
                                category[index],
                                height: 150.0,
                                width: 150.0,
                                fit: BoxFit.cover,),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(hotProducts[index]),
                              )
                            ],
                          ),
                        ),
                      );

                  },
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
