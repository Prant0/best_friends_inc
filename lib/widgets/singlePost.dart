import 'dart:convert';

import 'package:bestfriends/providers/comment.dart';
import 'package:bestfriends/providers/post.dart';
import 'package:bestfriends/screens/profile.dart';
import 'package:bestfriends/screens/singlePostDetails.dart';
import 'package:bestfriends/widgets/allComments.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:time_formatter/time_formatter.dart';


class SinglePost extends StatefulWidget {
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
  final DateTime createdAt;
  final Function likeFun;
  final String postType;
  final bool isMyPost;
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
    this.createdAt,
    this.likeFun,
    this.postType,
    this.isMyPost,
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
          builder: (context){
            return AllComments(postId:postId);
          });
  }

  @override
  _SinglePostState createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  bool isExpanded = true;
  showAlertDialog(BuildContext context, int postId) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("DELETE", style: TextStyle(
        color: Colors.red
      ),),
      onPressed:  ()async{
        await Provider.of<Posts>(context, listen: false).deletePost(postId);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Are you sure want to delete this post?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      margin: EdgeInsets.symmetric(vertical: 5),
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
                      Navigator.of(context).pushNamed(Profile.routeName, arguments: widget.posterId);
                    },
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.memory(
                            base64Decode(widget.posterImage),
                            fit: BoxFit.cover,
                            height: 35,
                            width: 35,
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          widget.posterName,
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  widget.posterIsVerified == 1
                      ? IconButton(
                          icon: Icon(
                            Icons.check_circle,
                            color: Colors.teal,
                            size: 20.0,
                          ),
                          tooltip: 'Verified User',
                        )
                      : Container(),
                  Spacer(),
                  Text(formatTime(widget.createdAt.millisecondsSinceEpoch)),
                  widget.isMyPost?
                      PopupMenuButton(
                        itemBuilder: (context){
                          return [
                            PopupMenuItem(
                              value: "edit",
                              child: Text("Edit"),
                            ),
                            PopupMenuItem(
                              value: "delete",
                              child: Text("Delete"),
                            ),
                          ];
                        },
                        onSelected: (val){
                          if(val=="edit"){
                            Navigator.of(context).pushReplacementNamed(SinglePostDetails.routeName, arguments: widget.postId);
                          }
                          else if(val=="delete")
                            {
                              showAlertDialog(context, widget.postId);
                            }
                        },
                      )
                      :Container(),
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
                    widget.desc == null
                        ? Container()
                        : InkWell(
                      onTap: (){
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              alignment: Alignment.topLeft,
                              child: Text(
                                widget.desc,
                                overflow: isExpanded?TextOverflow.ellipsis:TextOverflow.visible,
                              ),
                            ),
                        ),
                    widget.postImage.length < 1
                        ? Container()
                        : Container(
                            //tag: postId.toString(),
                            child: Container(
                              height: 250,
                              width: double.infinity,
                              child: Carousel(
                                images: widget.postImage.map((imageUrl) {
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
                                showIndicator: widget.postImage.length == 1 ? false : true,
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
                      widget.likeFun(widget.postId, !widget.isLiked);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(children: [
                        FaIcon(
                          widget.isLiked==null||widget.isLiked?FontAwesomeIcons.solidHeart:FontAwesomeIcons.heart,
                          color: Colors.teal,
                          size: 20.0,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${widget.likesCount}',
                          style: TextStyle(color: Colors.black45),
                        ),
                      ]),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                     // Navigator.of(context).pushNamed(AllComments.routeName, arguments: postId);
                      SinglePost.showComments(context, widget.postId);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        children: <Widget>[
                          FaIcon(
                            FontAwesomeIcons.comments,
                            color: Colors.teal,
                            size: 20.0,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${widget.commentsCount}',
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
                            '${widget.sharesCount}',
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
