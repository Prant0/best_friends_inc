import 'dart:convert';

import 'package:bestfriends/http/requests.dart';
import 'package:flutter/cupertino.dart';
class Post {
  final int id;
  final String desc;
  final int posterId;
  final String posterName;
  final String posterImage;
  final int posterIsVerified;
  final int active;
  final List<String> image;
  int likesCount;
  final int commentsCount;
  final int sharesCount;
  final String soundcloudTitle;
  final String soundcloudId;
  final String youtubeTitle;
  final String youtubeVideoId;
  final String location;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;
  final int sharedPostId;
  bool isLiked;
  Post({
    this.id,
    this.desc,
    this.posterId,
    this.posterName,
    this.posterImage,
    this.posterIsVerified,
    this.active,
    this.image,
    this.likesCount,
    this.commentsCount,
    this.sharesCount,
    this.soundcloudTitle,
    this.soundcloudId,
    this.youtubeTitle,
    this.youtubeVideoId,
    this.location,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.sharedPostId,
    this.isLiked,
  });
}

class Posts with ChangeNotifier {
  List<Post> _posts = [
//    Post(
//      id: 1,
//      desc:
//          'Hello World Second, Hello World Second, Hello World Second, Hello World Second, Hello World Second Hello World Second, Hello World Second, Hello World Second, Hello World Second, Hello World Second Hello World Second, Hello World Second, Hello World Second, Hello World Second, Hello World Second Hello World Second, Hello World Second, Hello World Second, Hello World Second, Hello World Second Hello World Second, Hello World Second, Hello World Second, Hello World Second, Hello World Second Hello World Second, Hello World Second, Hello World Second, Hello World Second, Hello World Second',
//      posterId: 1,
//      posterName: 'Bappa Raj',
//      posterImage: pic,
//      posterIsVerified: 1,
//      active: 1,
//      image: [pic, pic, pic],
//      likesCount: 2500,
//      commentsCount: 200,
//      sharesCount: 30,
//      soundcloudTitle: '',
//      soundcloudId: '',
//      youtubeTitle: '',
//      youtubeVideoId: '',
//      location: 'Dhaka',
//      type: 'Art',
//      createdAt: DateTime.now(),
//      updatedAt: DateTime.now(),
//      deletedAt: DateTime.now(),
//      sharedPostId: 0,
//    ),
//    Post(
//      id: 2,
//      desc:
//          'Hello World Second, Hello World Second, Hello World Second, Hello World Second, Hello World Second Hello World Second, Hello World Second, Hello World Second, Hello World Second, Hello World Second Hello World Second, Hello World Second, Hello World Second, Hello World Second, Hello World Second Hello World Second, Hello World Second, Hello World Second, Hello World Second, Hello World Second Hello World Second, Hello World Second, Hello World Second, Hello World Second, Hello World Second Hello World Second, Hello World Second, Hello World Second, Hello World Second, Hello World Second',
//      posterId: 1,
//      posterName: 'Mr. Joshim',
//      posterImage: pic,
//      posterIsVerified: 0,
//      active: 1,
//      image: [],
//      likesCount: 375,
//      commentsCount: 45,
//      sharesCount: 3,
//      soundcloudTitle: '',
//      soundcloudId: '',
//      youtubeTitle: '',
//      youtubeVideoId: '',
//      location: 'Dhaka',
//      type: 'Art',
//      createdAt: DateTime.now(),
//      updatedAt: DateTime.now(),
//      deletedAt: DateTime.now(),
//      sharedPostId: 0,
//    ),
//    Post(
//      id: 3,
//      desc: null,
//      posterId: 1,
//      posterName: 'Shakib Khan',
//      posterImage: pic,
//      posterIsVerified: 1,
//      active: 1,
//      image: [pic],
//      likesCount: 500,
//      commentsCount: 99,
//      sharesCount: 0,
//      soundcloudTitle: '',
//      soundcloudId: '',
//      youtubeTitle: '',
//      youtubeVideoId: '',
//      location: 'Dhaka',
//      type: 'Art',
//      createdAt: DateTime.now(),
//      updatedAt: DateTime.now(),
//      deletedAt: DateTime.now(),
//      sharedPostId: 0,
//    ),
  ];

  List<Post> get posts {
    return _posts.toList();
  }

  int itemCount() {
    return posts.length;
  }

  Post singlePost(int postId) {
    return _posts.firstWhere((element) => element.id == postId);
  }

  Future<bool> handleLike(int postId, bool isLiked)async{
    //TODO: Stop reloading entire list
    final response = await CustomHttpRequests.likePost(postId);
    var tempPost = _posts.firstWhere((element) => element.id==postId);
    tempPost.likesCount = response[1]["total_like"];
    if(response[0]["attached"].length>0)
      {
        tempPost.isLiked = true;
      }
    else if(response[0]["detached"].length>0)
    {
      tempPost.isLiked = false;
    }
    print(postId);
    notifyListeners();
    return true;
  }

  Future fetchTimeline()async{
    final data = await CustomHttpRequests.timelinePosts(0, 0);
    final postData = data["data"];
    if(postData == "No Post Found")
      return;
    final postMetaData = data["meta-data"];
    for(var group in postData){
      for(var singlePost in group){
        if(singlePost["type"]==null)
          {
            List<String> tempMedia = [];
            if (singlePost["media"] != null) {
              final decodedMedia = jsonDecode(singlePost["media"]);
              for (int i = 0; i < decodedMedia.length; i++) {
                tempMedia.add(decodedMedia["$i"]);
              }
            }
            Post newPost = Post(
              id: singlePost["id"],
              desc: singlePost["body"],
              image: tempMedia,
              createdAt: DateTime.parse(singlePost["created_at"]),
              updatedAt: DateTime.parse(singlePost["updated_at"]),
              posterId: singlePost["user"]["id"],
              posterName: singlePost["user"]["name"],
              posterIsVerified: singlePost["user"]["verified"],
              posterImage: singlePost["user"]["profile_pic"],
              likesCount: singlePost["likes_count"],
              commentsCount: singlePost["total_comment"],
              sharesCount: 0,
              isLiked: singlePost["is_liked"],
            );
            _posts.add(newPost);
          }
      }
    }
    notifyListeners();
  }

  void createPost(Map<String, dynamic> postData) {
    List<String> tempMedia = [];
    if (postData["media"] != null) {
      final decodedMedia = jsonDecode(postData["media"]);
      for (int i = 0; i < decodedMedia.length; i++) {
        tempMedia.add(decodedMedia["$i"]);
      }
    }
    Post newPost = Post(
      id: postData["id"],
      desc: postData["body"],
      image: tempMedia,
      createdAt: DateTime.parse(postData["created_at"]),
      updatedAt: DateTime.parse(postData["updated_at"]),
      posterId: postData["user"]["id"],
      posterName: postData["user"]["name"],
      posterIsVerified: postData["user"]["verified"],
      posterImage: postData["user"]["profile_pic"],
      likesCount: 0,
      commentsCount: 0,
      sharesCount: 0,
    );
    _posts.insert(0, newPost);
    notifyListeners();
  }

  Future<List<Post>> profilePosts(int userId, int page) async {
    List<Post> usersPosts = [];
    final data = await CustomHttpRequests.userPosts(userId, page);
    //print(data);
    for (var data in data["data"]) {
      List<String> tempMedia = [];
      if (data["media"] != null) {
        final decodedMedia = jsonDecode(data["media"]);
        for (int i = 0; i < decodedMedia.length; i++) {
          tempMedia.add(decodedMedia["$i"]);
        }
      }
      Post newPost = Post(
        id: data["id"],
        desc: data["body"],
        image: tempMedia,
        createdAt: DateTime.parse(data["created_at"]),
        updatedAt: DateTime.parse(data["updated_at"]),
        posterId: data["user_id"],
        posterName: data["user"]["name"],
        posterIsVerified: 0,
        posterImage: data["user"]["profile_pic"],
        likesCount: 0,
        commentsCount: 0,
        sharesCount: 0,
      );
      usersPosts.add(newPost);
    }
    return usersPosts;
  }
}
