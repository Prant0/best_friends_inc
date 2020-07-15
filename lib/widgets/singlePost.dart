import 'dart:convert';

import 'package:bestfriends/providers/comment.dart';
import 'package:bestfriends/screens/profile.dart';
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
  final bool isLiked;
  final Function likeFun;
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
    this.isLiked,
    this.likeFun,
  });

  static void showComments(BuildContext context, int postId) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        context: context,
        builder: (context) {
          final _comments = Provider.of<Comments>(context).postComments(postId);
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
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
                          child: Center(
                            child: IconButton(
                              icon: Icon(Icons.send),
                              color: Theme.of(context).primaryColor,
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: _comments.length < 1
                      ? Container(
                          alignment: Alignment.center,
                          child: Text('Be the first commenter'),
                        )
                      : Container(
                          child: ListView.builder(
                            itemBuilder: (context, i) {
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
                                  title: Text(
                                    _comments[i].cmntText,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  subtitle: Text(
                                    _comments[i].cmntrName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.thumb_up,
                                      color: _comments[i].likedByMe == true ? Colors.blue : Colors.grey,
                                    ),
                                  ));
                            },
                            itemCount: _comments.length,
                          ),
                        ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(Profile.routeName, arguments: posterId);
                    },
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.memory(
                            base64Decode(posterImage),
                            fit: BoxFit.cover,
                            height: 35,
                            width: 35,
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          posterName,
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  posterIsVerified == 1
                      ? IconButton(
                          icon: Icon(
                            Icons.check_circle,
                            color: Colors.teal,
                            size: 20.0,
                          ),
                          tooltip: 'Verified User',
                        )
                      : Container(),
                ],
              ),
            ),
            Container(
              child: InkWell(
                onTap: () {
                  //Navigator.pushNamed(context, SinglePostDetails.routeName, arguments: postId);
                },
                child: Container(
                  child: Column(children: [
                    desc == null
                        ? Container()
                        : Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            alignment: Alignment.topLeft,
                            child: Text(
                              desc,
                            ),
                          ),
                    postImage.length < 1
                        ? Container()
                        : Container(
                            //tag: postId.toString(),
                            child: Container(
                              height: 250,
                              width: double.infinity,
                              child: Carousel(
                                images: postImage.map((imageUrl) {
                                  return Image.memory(
                                    base64.decode(imageUrl),
                                    fit: BoxFit.cover,
                                  );
                                }).toList(),
                                dotSize: 2,
                                dotIncreaseSize: 2,
                                dotIncreasedColor: Theme.of(context).primaryColor,
                                dotSpacing: 15,
                                dotBgColor: Colors.transparent,
                                autoplay: false,
                                indicatorBgPadding: 5,
                                showIndicator: postImage.length == 1 ? false : true,
                              ),
                            ),
                          ),
                  ]),
                ),
              ),
            ),
            Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      likeFun(postId, !isLiked);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(children: [
                        Icon(
                          isLiked?Icons.thumb_down:Icons.thumb_up,
                          color: Colors.teal,
                          size: 20.0,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '$likesCount',
                          style: TextStyle(color: Colors.black45),
                        ),
                      ]),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showComments(context, postId);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.comment,
                            color: Colors.teal,
                            size: 20.0,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '$commentsCount',
                            style: TextStyle(color: Colors.black45),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.share,
                            color: Colors.teal,
                            size: 20.0,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '$sharesCount',
                            style: TextStyle(color: Colors.black45),
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
