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
  final int likesCount;
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
    //TODO: Add Dynamic Poster Name and Poster Image
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
