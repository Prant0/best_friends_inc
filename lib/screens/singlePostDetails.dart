import 'package:bestfriends/providers/post.dart';
import 'package:bestfriends/widgets/singlePost.dart';
import 'package:bestfriends/widgets/singlePostDetailsFAB.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SinglePostDetails extends StatelessWidget {
  static String routeName = '/SinglePostDetails';
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    final post = Provider.of<Posts>(context).singlePost(args);
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left:36),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SinglePostDetailsFAB(iconData: Icons.thumb_up, counts: post.likesCount, press: (){},),
            SinglePostDetailsFAB(iconData: Icons.comment, counts: post.commentsCount, press: (){SinglePost.showComments(context, post.id);},),
            SinglePostDetailsFAB(iconData: Icons.share, counts: post.sharesCount, press: (){},),
          ]
        ),
      ),
        body: SafeArea(
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Card(
                child: SingleChildScrollView(
                  child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 50,
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image(
                                image: AssetImage(
                                post.posterImage,
                              ),
                              fit: BoxFit.cover,
                              width: 35,
                              height: 35,
                              ),
                            ),
                            SizedBox(width: 15.0,),
                            Text(
                              post.posterName,
                            style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w800),
                            ),
                            SizedBox(width: 15.0,),
                            post.posterIsVerified == 1 ? Icon(Icons.check_circle,color: Colors.teal,size: 20.0,) : Container(),
                          ],
                        ),


                      ),
                      Container(
                            child: Column(
                              children: [
                              post.image==null?Container():Container(
                                height: 300,
                                child:Container(
                                  //tag: post.id.toString(),
                                    child: Container(
                                    width: double.infinity,
                                    child: Carousel(
                                      images: post.image.map((imageUrl) => ExactAssetImage(imageUrl)).toList(), 
                                      dotSize: 2,
                                      dotIncreaseSize: 2,dotIncreasedColor: Theme.of(context).primaryColor,
                                      dotSpacing: 15,
                                      dotBgColor: Colors.transparent,
                                      autoplay: false,
                                      indicatorBgPadding: 5,
                                      showIndicator: post.image.length==1?false:true,
                                    ),
                                  ),
                                ),
                              ),
                              post.desc==null?Container():Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(post.desc,),
                                  ),
                              ]
                            ),
                          ),
                    ],
                  ),
              ),
                ),
            ),
          ),
        ),
      ),
    );
  }
}