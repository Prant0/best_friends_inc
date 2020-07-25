import 'dart:convert';
import 'dart:typed_data';

import 'package:bestfriends/http/requests.dart';
import 'package:bestfriends/providers/post.dart';
import 'package:bestfriends/screens/profile.dart';
import 'package:bestfriends/widgets/allComments.dart';
import 'package:bestfriends/widgets/singlePost.dart';
import 'package:bestfriends/widgets/singlePostDetailsFAB.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class SinglePostDetails extends StatefulWidget {
  static String routeName = '/SinglePostDetails';

  @override
  _SinglePostDetailsState createState() => _SinglePostDetailsState();
}

class _SinglePostDetailsState extends State<SinglePostDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool onProgress = false;
  bool _init = true;
  final descController = TextEditingController();
  Post post;
  List<String> media;
  String responseMsg;
  List<Asset> images = List<Asset>();
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          autoCloseOnSelectionLimit: true,
          startInAllView: true,
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
    });

    media.add(await formatImages());
    setState(() {
      images = List<Asset>();
    });
  }

  createPost(BuildContext context) async {
    final Map<String, String> finalMedia = {};
    for(int i = 0; i<media.length; i++){
      finalMedia.putIfAbsent('$i', () => media[i]);
    }
    final dynamic postRequest = await CustomHttpRequests.updatePost(descController.text, finalMedia, post.id);
    if (postRequest["id"] != null) {
      Provider.of<Posts>(context, listen: false).updatePost(postRequest);
      responseMsg = "Post Update Successful";
      media.clear();
      descController.text = "";
    } else {
      responseMsg = "Something Wrong";
    }
    setState(() {
      onProgress = false;
      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(responseMsg),
        ),
      );
    });
  }

  Future<String> formatImages() async {
    String allImages = "";
    ByteData byteData;
    if (images.length > 0) {
      byteData = await images[0].getByteData();
      List<int> imageData = byteData.buffer.asUint8List();
      List<int> compressedImageData = await testCompressList(imageData);
      String baseData = base64Encode(compressedImageData);
      allImages =  baseData;
    }
    return allImages;
  }

  Future<List<int>> testCompressList(List<int> list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 300,
      minWidth: 500,
      quality: 40,
      rotate: 0,
    );
    return result;
  }


  @override
  void didChangeDependencies() {
    if(_init)
    {
      post = Provider.of<Posts>(context).singlePost(ModalRoute.of(context).settings.arguments);
      descController.text = post.desc;
      media = post.image;
      setState(() {
        _init = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.of(context).pushReplacementNamed(Profile.routeName, arguments: post.posterId);
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: NeumorphicAppBar(
          centerTitle: true,
          title: NeumorphicText("Update Post", style: NeumorphicStyle(color: Theme.of(context).primaryColor),),
          actions: <Widget>[
            NeumorphicButton(
              padding: EdgeInsets.all(0),
              child: Center(
                child: NeumorphicIcon(
                  FontAwesomeIcons.cloudUploadAlt,
                  size: 20,
                  style: NeumorphicStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              onPressed: (){
              setState(() {
                onProgress = true;
              });
              createPost(context);
            },
            ),
          ],
        ),
          body: SafeArea(
          child: onProgress?Container(alignment: Alignment.center,child: CircularProgressIndicator(),):Neumorphic(
            padding: EdgeInsets.symmetric(vertical: 10),
            //color: Colors.white,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                height: MediaQuery.of(context).size.height,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Neumorphic(
                          style: NeumorphicStyle(
                            intensity: 20,
                            shape: NeumorphicShape.concave,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: TextFormField(
                            controller: descController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Whats going on...!!!",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        media.length<1?
                        Container():
                        Container(
                          height: 300,
                          child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            itemBuilder: (context, int i){
                              if(media[i]==null)
                              {
                                return Container();
                              }
                              else{
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  child: Stack(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.memory(
                                          base64.decode(media[i]),
                                          fit: BoxFit.cover,
                                          height: 150,
                                          width: double.infinity,
                                        ),
                                      ),
                                      Positioned(
                                        top: 1,
                                        right: 1,
                                        child: IconButton(
                                          icon: NeumorphicIcon(Icons.indeterminate_check_box,),
                                          onPressed: (){
                                            setState(() {
                                              media.removeAt(i);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            itemCount: media.length,
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            loadAssets();
                          },
                          child: Container(
                            height: 150,
                            width: 150,
                            alignment: Alignment.center,
                            child: NeumorphicIcon(Icons.add_circle, size: 50,),
                          ),
                        ),
                      ]
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}