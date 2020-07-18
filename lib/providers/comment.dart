import 'package:bestfriends/http/requests.dart';
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
  final int cmntrId;
  final DateTime cmntTime;

  Comment({this.cmntTime,this.cmntrId,this.postId, this.cmntId, this.cmntrPic, this.cmntrName, this.cmntrIsVerified, this.cmntText, this.cmntLikes, this.likedByMe});


}

class Comments with ChangeNotifier{
  List<Comment> _comments = [
//    Comment(
//      postId: 0,
//      cmntId: 10,
//      cmntrPic: 'images/11.jpg',
//      cmntrName: 'Rafiqul Islam',
//      cmntrIsVerified: false,
//      cmntText: 'Nice pic',
//      cmntLikes: 100,
//      likedByMe: true,
//    ),
//    Comment(
//      postId: 0,
//      cmntId: 11,
//      cmntrPic: 'images/22.jpg',
//      cmntrName: 'Ibrahim Hossain',
//      cmntrIsVerified: false,
//      cmntText: 'Wowwww',
//      cmntLikes: 100,
//      likedByMe: false,
//    ),
//    Comment(
//      postId: 0,
//      cmntId: 12,
//      cmntrPic: 'images/33.jpg',
//      cmntrName: 'Awolad Hossain',
//      cmntrIsVerified: false,
//      cmntText: 'Hello Sweety, Add me',
//      cmntLikes: 100,
//      likedByMe: true,
//    ),
//    Comment(
//      postId: 1,
//      cmntId: 10,
//      cmntrPic: 'images/11.jpg',
//      cmntrName: 'Rafiqul Islam',
//      cmntrIsVerified: false,
//      cmntText: 'Nice pic',
//      cmntLikes: 100,
//      likedByMe: false,
//    ),
//    Comment(
//      postId: 1,
//      cmntId: 11,
//      cmntrPic: 'images/22.jpg',
//      cmntrName: 'Ibrahim Hossain',
//      cmntrIsVerified: false,
//      cmntText: 'Wowwww',
//      cmntLikes: 100,
//      likedByMe: true,
//    ),
//    Comment(
//      postId: 1,
//      cmntId: 12,
//      cmntrPic: 'images/33.jpg',
//      cmntrName: 'Awolad Hossain',
//      cmntrIsVerified: false,
//      cmntText: 'Hello Sweety, Add me',
//      cmntLikes: 100,
//      likedByMe: false,
//    ),
//    Comment(
//      postId: 1,
//      cmntId: 10,
//      cmntrPic: 'images/11.jpg',
//      cmntrName: 'Rafiqul Islam',
//      cmntrIsVerified: false,
//      cmntText: 'Nice pic',
//      cmntLikes: 100,
//      likedByMe: true,
//    ),
//    Comment(
//      postId: 1,
//      cmntId: 11,
//      cmntrPic: 'images/22.jpg',
//      cmntrName: 'Ibrahim Hossain',
//      cmntrIsVerified: false,
//      cmntText: 'Wowwww',
//      cmntLikes: 100,
//      likedByMe: true,
//    ),
//    Comment(
//      postId: 1,
//      cmntId: 12,
//      cmntrPic: 'images/33.jpg',
//      cmntrName: 'Awolad Hossain',
//      cmntrIsVerified: false,
//      cmntText: 'Hello Sweety, Add me, Hello Sweety, Add me, Hello Sweety, Add me, Hello Sweety, Add me , Hello Sweety, Add me Hello Sweety, Add me Hello Sweety, Add me Hello Sweety, Add me',
//      cmntLikes: 100,
//      likedByMe: false,
//    ),
  ];


  List<Comment> postComments(int id){
    final _linkedComments = _comments.where((cmnt) => cmnt.postId==id);
    return _linkedComments.toList();
  }

  void createComment(int postId, String commentText, String profilePic, String commenterName)async{
    final data = await CustomHttpRequests.createComment(commentText, postId);
    _comments.insert(0, Comment(
      postId: postId,
      cmntId: data["id"],
      cmntrPic: profilePic,
      cmntrName: data["user"]["name"],
      cmntrIsVerified: data["user"]["verified"]!=0,
      cmntText: data["body"],
      cmntLikes: 0,
      likedByMe: false,
      cmntTime: DateTime.parse(data["created_at"]),
    ));
    notifyListeners();
  }

  Future<List<Comment>> getComments(int postId)async{
    _comments.clear();
    final data = await CustomHttpRequests.getProfileComments(postId);
    for(var comment in data){
      _comments.add(Comment(
        postId: comment["post_id"],
        cmntId: comment["id"],
        cmntrPic: comment["user"]["profile_pic"],
        cmntrName: comment["user"]["name"],
        cmntrId: comment["user"]["id"],
        cmntrIsVerified: comment["user"]["verified"]!=0,
        cmntText: comment["body"],
        cmntLikes: comment["total_likes"]["total_like"],
        likedByMe: comment["is_liked"],
        cmntTime: DateTime.parse(comment["created_at"]),
      ));
    }
    notifyListeners();
    return _comments.toList();
  }
}