import 'package:bestfriends/providers/comment.dart';
import 'package:bestfriends/screens/profile.dart';
import 'package:bestfriends/screens/singlePostDetails.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SinglePost extends StatelessWidget {
  final String posterImage;
  final String posterName;
  final int posterIsVerified;
  final String desc;
  final List<String> postImage;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final int postId;
  final int posterId;
  SinglePost({
    this.posterImage,
    this.posterName,
    this.posterIsVerified,
    this.desc,
    this.postImage,
    this.likesCount,
    this.commentsCount,
    this.sharesCount,
    this.postId,
    this.posterId,
  });

  static void showComments(BuildContext context, int postId){
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25),),
      ),
      context: context,
      builder: (context){
      final _comments = Provider.of<Comments>(context).postComments(postId);
      return Container(
            height: MediaQuery.of(context).size.height*0.8,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 2,
                      child: Container(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Add a comment',
                                ),
                              ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(child:
                            IconButton(
                              icon: Icon(Icons.send),
                              color: Theme.of(context).primaryColor,
                              onPressed: (){},
                            ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                        child: _comments.length<1?Container(
                          alignment: Alignment.center,
                          child: Text('Be the first commenter'),
                        ):Container(
                        child: ListView.builder(
                          itemBuilder: (context, i){
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(_comments[i].cmntrPic),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(_comments[i].cmntText,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              ),
                              subtitle: Text(_comments[i].cmntrName,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                              ),
                              trailing: IconButton(
                                onPressed: (){},
                                icon: Icon(
                                  Icons.thumb_up, 
                                  color: _comments[i].likedByMe==true?Colors.blue:Colors.grey,
                                ),
                                )
                            );
                          },
                          itemCount: _comments.length,
                        ),
                      ),
                  ),
                ],
            ),
          );
      }
    );
}

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal:10.0, vertical: 5),
        child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        height: 300.0,
        child: Column(
          children: <Widget>[
            Expanded(
              flex:3,
              child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pushNamed(Profile.routeName, arguments: posterId);
                      },
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image(
                              image: AssetImage(
                              posterImage,
                            ),
                            fit: BoxFit.cover,
                            width: 35,
                            height: 35,
                            ),
                          ),
                          SizedBox(width: 15.0,),
                          Text(
                            posterName,
                          style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    posterIsVerified == 1 ? IconButton(
                      icon: Icon(Icons.check_circle,color: Colors.teal,size: 20.0,),
                      tooltip: 'Verified User',
                    ) : Container(),
                  ],
                ),
            ),
            Expanded(
              flex: 8,
              child: InkWell(
                onTap: (){
                  Navigator.pushNamed(context, SinglePostDetails.routeName, arguments:postId);
                },
                  child: Container(
                  child: Column(
                    children: [
                      desc==null?Container():Expanded(
                      flex: postImage==null?8:1,
                      child:Container(
                        alignment: Alignment.topLeft,
                        child: Text(desc, overflow: postImage==null?TextOverflow.fade:TextOverflow.ellipsis,),
                        ),
                    ),
                    postImage==null?Container():Expanded(
                      flex: 8,
                      child:Container(
                        //tag: postId.toString(),
                        child: Container(
                          width: double.infinity,
                          child: Carousel(
                            images: postImage.map((imageUrl) => ExactAssetImage(imageUrl)).toList(), 
                            dotSize: 2,
                            dotIncreaseSize: 2,dotIncreasedColor: Theme.of(context).primaryColor,
                            dotSpacing: 15,
                            dotBgColor: Colors.transparent,
                            autoplay: false,
                            indicatorBgPadding: 5,
                            showIndicator: postImage.length==1?false:true,
                          ),
                        ),
                      ),
                    ),
                        ]
                      ),
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: (){},
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal:10,vertical:5),
                          child: Row(
                          children: [
                            Icon(Icons.thumb_up,color: Colors.teal, size: 20.0,),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '$likesCount',style: TextStyle(color: Colors.black45),
                            ),
                          ]
                        ),
                      ),
                  ),
                  InkWell(
                    onTap: (){
                      showComments(context, postId);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical:5),
                        child: Row(
                        children: <Widget>[
                          Icon(Icons.comment, color: Colors.teal,size: 20.0,),
                          SizedBox(
                              width: 5,
                            ),
                          Text(
                            '$commentsCount',style: TextStyle(color: Colors.black45),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){},
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal:10, vertical:5),
                        child: Row(
                        children: <Widget>[
                          Icon(Icons.share, color: Colors.teal,size: 20.0,),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                              '$sharesCount',style: TextStyle(color: Colors.black45),
                            ),
                        ],
                    ),
                      ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}