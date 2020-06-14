import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Post{
  final int id;
  final String desc;
  final int timelineId;
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
    this.timelineId,
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

class Posts with ChangeNotifier{
  List<Post> _posts = [
    Post(
      id: 1,
      desc: 'Hello World Second, Hello World Second, Hello World Second, Hello World Second, Hello World Second Hello World Second, Hello World Second, Hello World Second, Hello World Second, Hello World Second Hello World Second, Hello World Second, Hello World Second, Hello World Second, Hello World Second Hello World Second, Hello World Second, Hello World Second, Hello World Second, Hello World Second Hello World Second, Hello World Second, Hello World Second, Hello World Second, Hello World Second Hello World Second, Hello World Second, Hello World Second, Hello World Second, Hello World Second',
      timelineId: 1,
      posterId: 1,
      posterName: 'Bappa Raj',
      posterImage: 'images/11.jpg',
      posterIsVerified: 1,
      active: 1,
      image: ['images/1.jpg','images/11.jpg','images/22.jpg'],
      likesCount: 2500,
      commentsCount: 200,
      sharesCount: 30,
      soundcloudTitle: '',
      soundcloudId: '',
      youtubeTitle: '',
      youtubeVideoId: '',
      location: 'Dhaka',
      type: 'Art',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      deletedAt: DateTime.now(),
      sharedPostId: 0,
    ),
    Post(
      id: 2,
      desc: 'Hello World Second, Hello World Second, Hello World Second, Hello World Second, Hello World Second Hello World Second, Hello World Second, Hello World Second, Hello World Second, Hello World Second Hello World Second, Hello World Second, Hello World Second, Hello World Second, Hello World Second Hello World Second, Hello World Second, Hello World Second, Hello World Second, Hello World Second Hello World Second, Hello World Second, Hello World Second, Hello World Second, Hello World Second Hello World Second, Hello World Second, Hello World Second, Hello World Second, Hello World Second',
      timelineId: 1,
      posterId: 1,
      posterName: 'Mr. Joshim',
      posterImage: 'images/22.jpg',
      posterIsVerified: 0,
      active: 1,
      image: null,
      likesCount: 375,
      commentsCount: 45,
      sharesCount: 3,
      soundcloudTitle: '',
      soundcloudId: '',
      youtubeTitle: '',
      youtubeVideoId: '',
      location: 'Dhaka',
      type: 'Art',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      deletedAt: DateTime.now(),
      sharedPostId: 0,
    ),
    Post(
      id: 3,
      desc: null,
      timelineId: 1,
      posterId: 1,
      posterName: 'Shakib Khan',
      posterImage: 'images/33.jpg',
      posterIsVerified: 1,
      active: 1,
      image: ['images/3.jpg'],
      likesCount: 500,
      commentsCount: 99,
      sharesCount: 0,
      soundcloudTitle: '',
      soundcloudId: '',
      youtubeTitle: '',
      youtubeVideoId: '',
      location: 'Dhaka',
      type: 'Art',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      deletedAt: DateTime.now(),
      sharedPostId: 0,
    ),
  ];

  List<Post> get posts{
    return _posts.toList();
  }

  int itemCount(){
    return posts.length;
  }

  Post singlePost(int postId){
    return _posts.firstWhere((element) => element.id==postId);
  }

}