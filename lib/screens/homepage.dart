
import 'package:bestfriends/screens/login.dart';
import 'package:bestfriends/screens/postStatus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/post.dart';
import '../widgets/singlePost.dart';
import 'package:provider/provider.dart';
import '../widgets/drawer.dart';

//TODO: Add Products
//TODO: Infinity Scroll to timeline

class HomePage extends StatefulWidget {
  static const String routeName = '/HomePage';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  bool _init = true;
  int myUserId;
  SharedPreferences sharedPreferences;
  List<Post> allPosts = [];
  @override
  void initState() {
    checkLoginStatus();
    super.initState();
  }
  checkLoginStatus()async{
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("token")==null)
      {
        Navigator.of(context).pushReplacementNamed(Login_Page.routeName);
      }
    else{
      myUserId = int.parse(sharedPreferences.getString("userId"));
    }
  }

  @override
  void didChangeDependencies()async{
    if(_init){
      await Provider.of<Posts>(context).fetchTimeline();
      setState(() {
        _init = false;
      });
    }
    super.didChangeDependencies();
  }

  void likeAction(int postId, bool isLiked){
    Provider.of<Posts>(context, listen: false).handleLike(postId, isLiked);
  }

  @override
  Widget build(BuildContext context) {
    //TODO: implement timeline pull to refresh and infinity scroll
    allPosts = Provider.of<Posts>(context).posts;
    return Scaffold(
      backgroundColor:Color(0xffE2E4EA) ,
      appBar: AppBar(
        title: Center(child: Text("Best Friends Inc",style: TextStyle(),)),
      ),
      drawer: CustomDrawer(),
      endDrawer: CustomDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.pushNamed(context, PostStatus.routeName);
        },
        isExtended: true,
        icon: Icon(Icons.add),
        label: Text('Post'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: allPosts.length==null?Container():Container(
        child: ListView.builder(
          itemCount: allPosts.length,
          itemBuilder: (BuildContext context, int i){
          return allPosts[i].type=="product"?Container(
            height: 20,
            width: 50,
            color: Colors.red,
          ):SinglePost(
            posterImage: allPosts[i].posterImage,
            posterName: allPosts[i].posterName,
            posterIsVerified: allPosts[i].posterIsVerified,
            desc: allPosts[i].desc,
            postImage: allPosts[i].image,
            likesCount: allPosts[i].likesCount,
            commentsCount: allPosts[i].commentsCount,
            sharesCount: allPosts[i].sharesCount,
            postId: allPosts[i].id,
            posterId: allPosts[i].posterId,
            isLiked: allPosts[i].isLiked,
            createdAt: allPosts[i].createdAt,
            likeFun: likeAction,
            isMyPost: myUserId == allPosts[i].posterId,
          );
        }),
      )
    );
  }
}