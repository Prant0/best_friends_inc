import 'package:bestfriends/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:bestfriends/providers/comment.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_formatter/time_formatter.dart';

//TODO: Click commenter pic go to his profile
//TODO: Like a comment and show likes count
//TODO: Infinity Scroll to comments

class AllComments extends StatefulWidget {
  static const String routeName = '/AllComments';
  final int postId;
  AllComments({this.postId});
  @override
  _AllCommentsState createState() => _AllCommentsState();
}

class _AllCommentsState extends State<AllComments> {
  bool _init=true;
  final _commentController = TextEditingController();
  List<Comment> _allComments=[];
  SharedPreferences sharedPreferences;
  Future<List<String>> getProfilePic()async{
    sharedPreferences = await SharedPreferences.getInstance();
    return [sharedPreferences.getString("profile_pic"),sharedPreferences.getString("name")];
  }

  @override
  void didChangeDependencies() async{
    if(_init)
      {
        await Provider.of<Comments>(context).getComments(widget.postId);
      }
    setState(() {
      _init = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _commentsProvider = Provider.of<Comments>(context);
    _allComments = _commentsProvider.postComments(widget.postId);
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: IconButton(
                        icon: Icon(Icons.send),
                        color: Theme.of(context).primaryColor,
                        onPressed: ()async{
                          List<String> data = await getProfilePic();
                          _commentsProvider.createComment(widget.postId, _commentController.text, data[0], data[1]);
                          _commentController.clear();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: _allComments.length < 1
                ? Container(
              alignment: Alignment.center,
              child: Text('Be the first commenter'),
            )
                : Container(
              child: ListView.builder(
                itemBuilder: (context, i) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        dense: true,
                        leading: InkWell(
                          onTap: (){
                            print(_allComments[i].cmntrId.runtimeType);
                            Navigator.of(context).pushNamed(Profile.routeName, arguments: _allComments[i].cmntrId);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.memory(
                              base64Decode(_allComments[i].cmntrPic),
                              fit: BoxFit.cover,
                              height: 35,
                              width: 35,
                            ),
                          ),
                        ),
                        title: Text(
                          _allComments[i].cmntText,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              _allComments[i].cmntrName,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            Text(formatTime(_allComments[i].cmntTime.millisecondsSinceEpoch)),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              onTap: () {},
                              child: FaIcon(
                                _allComments[i].likedByMe?FontAwesomeIcons.solidHeart:FontAwesomeIcons.heart,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(_allComments[i].cmntLikes.toString(),),
                          ],
                        ),

                      ),
                      Divider(),
                    ],
                  );
                },
                itemCount: _allComments.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
