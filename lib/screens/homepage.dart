
import 'package:bestfriends/screens/login.dart';
import 'package:bestfriends/screens/postStatus.dart';
import 'package:bestfriends/widgets/companyDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController = ScrollController();
  dynamic meta = {
    "call": 0.toString(),
    "total_product_shown": 0.toString(),
  };
  bool isLoading = true;
  bool isFetched = false;
  bool fetching = false;
  bool _init = true;
  int myUserId;
  SharedPreferences sharedPreferences;
  List<Post> allPosts = [];
  @override
  void initState() {
    checkLoginStatus();
    _scrollController.addListener(() {
      if ((_scrollController.position.pixels == _scrollController.position.maxScrollExtent) && fetching == false) {
        morePosts();
      }
    });
    super.initState();
  }
  void morePosts() async {
    print("fetching");
    setState(() {
      fetching = true;
      _init = true;
      didChangeDependencies();
    });
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
      final metaDataCool = await Provider.of<Posts>(context, listen: false).fetchTimeline(meta);
      meta = {
        "call": metaDataCool["call"].toString(),
        "total_product_shown": metaDataCool["total_product_shown"].toString()
      };
      setState(() {
        isLoading = false;
        isFetched = true;
        _init = false;
        fetching = false;
      });
    }
    super.didChangeDependencies();
  }

  void likeAction(int postId, bool isLiked){
    Provider.of<Posts>(context, listen: false).handleLike(postId, isLiked);
  }

  @override
  Widget build(BuildContext context) {
    allPosts = Provider.of<Posts>(context).posts;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:Color(0xffE2E4EA) ,
      appBar: AppBar(
        backgroundColor: Color(0xFFE2E4EA),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          NeumorphicButton(
            style: NeumorphicStyle(
              lightSource: LightSource.right,
              //depth: 5,
              //color: Color(0xFFE2E4EA),
              //shape: NeumorphicShape.concave,
            ),
            child: Center(child: FaIcon(FontAwesomeIcons.bars, color: Theme.of(context).iconTheme.color, size: 15,)),
            onPressed: (){
              _scaffoldKey.currentState.openEndDrawer();
            },
          ),
        ],
        leading: NeumorphicButton(
          style: NeumorphicStyle(
            //color: Color(0xFFE2E4EA),
            //depth: 5,
            //shape: NeumorphicShape.concave,
          ),
          child: Center(child:FaIcon(FontAwesomeIcons.user, color: Theme.of(context).iconTheme.color, size: 15,),),
          onPressed: (){
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Center(
          child: FittedBox(
            child: NeumorphicText("Best Friends Inc.",style: NeumorphicStyle(color: Theme.of(context).primaryColor,),
            textStyle: NeumorphicTextStyle(
                fontSize: 18,
                fontFamily: "Courgette",
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      drawer: CustomDrawer(_scaffoldKey),
      endDrawer: CompanyDrawer(_scaffoldKey),
      floatingActionButton:
          NeumorphicFloatingActionButton(
            style: NeumorphicStyle(
              shape: NeumorphicShape.convex
             // intensity: 20.0,
             // boxShape: NeumorphicBoxShape.circle(),
            ),
            child: Icon(Icons.add, color: Theme.of(context).primaryColor,),
            onPressed: (){
              Navigator.pushNamed(context, PostStatus.routeName);
            },
          ),
//      FloatingActionButton.extended(
//        onPressed: (){
//          Navigator.pushNamed(context, PostStatus.routeName);
//        },
//        isExtended: true,
//        icon: Icon(Icons.add, color: Theme.of(context).primaryColor,),
//        label: Text('Post', style: TextStyle(color: Theme.of(context).primaryColor),),
//        backgroundColor: Colors.white,
//      ),
      body: isLoading?Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ):isFetched&&allPosts.length<1?Container(
        alignment: Alignment.center,
        child: Text("No posts found, follow someone to see posts"),
      ):Stack(
        children: <Widget>[
          RefreshIndicator(
            onRefresh: ()async{
              Provider.of<Posts>(context,listen: false).refreshPostList();
              meta = {
                "call": 0.toString(),
                "total_product_shown": 0.toString(),
              };
              setState(() {
                fetching = true;
                _init = true;
                isLoading = true;
                didChangeDependencies();
              });
            },
            child: Neumorphic(
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: allPosts.length,
                  itemBuilder: (BuildContext context, int i){
                    return allPosts[i].type=="product"?Container(
                      height: 300,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                        child: Stack(
                          children: <Widget>[
                            Image.asset("images/product.jpg", fit: BoxFit.cover, width: double.infinity, height: double.infinity,),
                            Positioned(
                              bottom: 15,
                              right: 15,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white,

                                ),
                                child: IconButton(
                                  onPressed: (){},
                                  icon: Icon(Icons.add_shopping_cart, color: Theme.of(context).primaryColor,),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
            ),
          ),
          fetching?Positioned(
            bottom: 0,
            child: Container(
              height: 3,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              child: LinearProgressIndicator(),
            ),
          ):Container()
        ],
      )
    );
  }
}