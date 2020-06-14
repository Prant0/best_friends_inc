import 'package:flutter/cupertino.dart';

class Comment{
  final int postId;
  final int cmntId;
  final String cmntrPic;
  final String cmntrName;
  final bool cmntrIsVerified;
  final String cmntText;
  final int cmntLikes;
  final bool likedByMe;

  Comment({this.postId, this.cmntId, this.cmntrPic, this.cmntrName, this.cmntrIsVerified, this.cmntText, this.cmntLikes, this.likedByMe});


}

class Comments with ChangeNotifier{
  List<Comment> _comments = [
    Comment(
      postId: 1,
      cmntId: 10,
      cmntrPic: 'images/11.jpg',
      cmntrName: 'Rafiqul Islam',
      cmntrIsVerified: false,
      cmntText: 'Nice pic',
      cmntLikes: 100,
      likedByMe: true,
    ),
    Comment(
      postId: 1,
      cmntId: 11,
      cmntrPic: 'images/22.jpg',
      cmntrName: 'Ibrahim Hossain',
      cmntrIsVerified: false,
      cmntText: 'Wowwww',
      cmntLikes: 100,
      likedByMe: false,
    ),
    Comment(
      postId: 1,
      cmntId: 12,
      cmntrPic: 'images/33.jpg',
      cmntrName: 'Awolad Hossain',
      cmntrIsVerified: false,
      cmntText: 'Hello Sweety, Add me',
      cmntLikes: 100,
      likedByMe: true,
    ),
    Comment(
      postId: 1,
      cmntId: 10,
      cmntrPic: 'images/11.jpg',
      cmntrName: 'Rafiqul Islam',
      cmntrIsVerified: false,
      cmntText: 'Nice pic',
      cmntLikes: 100,
      likedByMe: false,
    ),
    Comment(
      postId: 1,
      cmntId: 11,
      cmntrPic: 'images/22.jpg',
      cmntrName: 'Ibrahim Hossain',
      cmntrIsVerified: false,
      cmntText: 'Wowwww',
      cmntLikes: 100,
      likedByMe: true,
    ),
    Comment(
      postId: 1,
      cmntId: 12,
      cmntrPic: 'images/33.jpg',
      cmntrName: 'Awolad Hossain',
      cmntrIsVerified: false,
      cmntText: 'Hello Sweety, Add me',
      cmntLikes: 100,
      likedByMe: false,
    ),
    Comment(
      postId: 1,
      cmntId: 10,
      cmntrPic: 'images/11.jpg',
      cmntrName: 'Rafiqul Islam',
      cmntrIsVerified: false,
      cmntText: 'Nice pic',
      cmntLikes: 100,
      likedByMe: true,
    ),
    Comment(
      postId: 1,
      cmntId: 11,
      cmntrPic: 'images/22.jpg',
      cmntrName: 'Ibrahim Hossain',
      cmntrIsVerified: false,
      cmntText: 'Wowwww',
      cmntLikes: 100,
      likedByMe: true,
    ),
    Comment(
      postId: 1,
      cmntId: 12,
      cmntrPic: 'images/33.jpg',
      cmntrName: 'Awolad Hossain',
      cmntrIsVerified: false,
      cmntText: 'Hello Sweety, Add me, Hello Sweety, Add me, Hello Sweety, Add me, Hello Sweety, Add me , Hello Sweety, Add me Hello Sweety, Add me Hello Sweety, Add me Hello Sweety, Add me',
      cmntLikes: 100,
      likedByMe: false,
    ),
  ];


  List<Comment> postComments(int id){
    final _linkedComments = _comments.where((cmnt) => cmnt.postId==id);
    return _linkedComments.toList();
  }

}