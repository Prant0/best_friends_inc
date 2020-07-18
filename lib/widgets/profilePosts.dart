import 'package:bestfriends/providers/post.dart';
import 'package:bestfriends/widgets/singlePost.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePosts extends StatefulWidget {
  @override
  _ProfilePostsState createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePosts> {
  ScrollController _scrollController = ScrollController();
  bool isLoaded = false, fetching = false;
  SharedPreferences sharedPreferences;
  int myUserId;
  int currentPage = 1;
  List<dynamic> userPosts = [];
  @override
  void initState() {
    _scrollController.addListener(() {
      if ((_scrollController.position.pixels == _scrollController.position.maxScrollExtent) && fetching == false) {
        morePosts();
      }
    });
    super.initState();
  }

  void morePosts() async {
    setState(() {
      fetching = true;
    });
    print(currentPage);
    final morePosts = await Provider.of<Posts>(context, listen: false).profilePosts(ModalRoute.of(context).settings.arguments, currentPage + 1);
    for (Post newPost in morePosts) {
      userPosts.add(newPost);
    }

    setState(() {
      fetching = false;
      currentPage++;
    });
  }

  @override
  void didChangeDependencies() async {
    if (isLoaded == false) {
      try {
        userPosts = await Provider.of<Posts>(context).profilePosts(ModalRoute.of(context).settings.arguments, currentPage);
        sharedPreferences = await SharedPreferences.getInstance();
        myUserId = int.parse(sharedPreferences.getString("userId"));
        if (mounted) {
          setState(() {
            isLoaded = true;
          });
        }
      } catch (e) {
        print(e);
      }
    }
    super.didChangeDependencies();
  }

  void likeAction(int postId, bool isLiked){
    Provider.of<Posts>(context, listen: false).handleLike(postId, isLiked);
    final tempPost = userPosts.firstWhere((element) => element.id==postId);
    final tempIndex = userPosts.indexOf(tempPost);
    print(tempIndex);

        userPosts[tempIndex].isLiked = !userPosts[tempIndex].isLiked;

  }

  @override
  void dispose() {
    isLoaded = false;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: isLoaded==true && userPosts.length < 1
              ? Container(alignment: Alignment.center, child: Text("No Posts Yet"),)
              : userPosts.length < 1? Center(child: CircularProgressIndicator()) : ListView.builder(
                  controller: _scrollController,
                  itemCount: userPosts.length,
                  itemBuilder: (BuildContext context, int i) {
                    return SinglePost(
                      posterImage: userPosts[i].posterImage,
                      posterName: userPosts[i].posterName,
                      posterIsVerified: userPosts[i].posterIsVerified,
                      desc: userPosts[i].desc,
                      postImage: userPosts[i].image,
                      isLiked: userPosts[i].isLiked,
                      likesCount: userPosts[i].likesCount,
                      commentsCount: userPosts[i].commentsCount,
                      sharesCount: userPosts[i].sharesCount,
                      postId: userPosts[i].id,
                      posterId: userPosts[i].posterId,
                      createdAt: userPosts[i].createdAt,
                      isMyPost: myUserId==userPosts[i].posterId,
                      likeFun: likeAction,
                    );
                  }),
        ),
        fetching == true
            ? Positioned(
                bottom: 0,
                child: Container(
                  height: 3,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.bottomCenter,
                  child: LinearProgressIndicator(),
                ),
              )
            : Container(),
      ],
    );
  }
}
