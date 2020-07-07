import 'package:bestfriends/providers/post.dart';
import 'package:bestfriends/widgets/singlePost.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePosts extends StatefulWidget {
  @override
  _ProfilePostsState createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePosts> {
  ScrollController _scrollController = ScrollController();
  bool isLoaded = false, fetching = false;
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
        userPosts = await Provider.of<Posts>(context, listen: false).profilePosts(ModalRoute.of(context).settings.arguments, currentPage);
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
          child: userPosts.length < 1
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: userPosts.length,
                  itemBuilder: (BuildContext context, int i) {
                    return SinglePost(
                      posterImage: userPosts[i].posterImage,
                      posterName: userPosts[i].posterName,
                      posterIsVerified: userPosts[i].posterIsVerified,
                      desc: userPosts[i].desc,
                      postImage: userPosts[i].image,
                      likesCount: userPosts[i].likesCount,
                      commentsCount: userPosts[i].commentsCount,
                      sharesCount: userPosts[i].sharesCount,
                      postId: userPosts[i].id,
                      posterId: userPosts[i].posterId,
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
