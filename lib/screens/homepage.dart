
import 'package:bestfriends/screens/login.dart';
import 'package:bestfriends/screens/postStatus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/post.dart';
import '../widgets/singlePost.dart';
import 'package:provider/provider.dart';
import '../widgets/drawer.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/HomePage';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  String _x ="one";
  SharedPreferences sharedPreferences;
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
  }

  @override
  Widget build(BuildContext context) {
  int count =  Provider.of<Posts>(context).itemCount();
  List<Post> allPosts = Provider.of<Posts>(context).posts;
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
      body: Container(
        child: ListView.builder(
          itemCount: allPosts.length,
          itemBuilder: (BuildContext context, int i){
          return SinglePost(
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
          );
        }),
      )
    );
  }
}