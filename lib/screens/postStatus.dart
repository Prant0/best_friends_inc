import 'dart:convert';
import 'dart:typed_data';

import 'package:bestfriends/http/requests.dart';
import 'package:bestfriends/providers/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';



class PostStatus extends StatefulWidget {
  static const String routeName = '/postStatusScreen';

  @override
  _PostStatusState createState() => _PostStatusState();
}

class _PostStatusState extends State<PostStatus> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController bodyController = TextEditingController();
  String body, responseMsg;
  bool onProgress = false;
  var imagesList;
  List<Asset> images = List<Asset>();
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
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

    imagesList = await formatImages();
    setState(() {});
  }

  createPost(BuildContext context) async {
    final Map<String, dynamic> postRequest = await CustomHttpRequests.createPost(bodyController.text, imagesList);
    if (postRequest["message"].toString() == "Success") {
      responseMsg = "Success";
      Provider.of<Posts>(context, listen: false).createPost(postRequest);
    } else {
      responseMsg = "Something Wrong";
    }
    setState(() {
      onProgress = false;
      if(responseMsg=="Success")
        {
          images = List<Asset>();
          bodyController.text = "";
        }
      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(responseMsg),
        ),
      );
    });
  }

  Future<Map<String, String>> formatImages() async {
    Map<String, String> allImages = {};
    ByteData byteData;
    if (images.length > 0) {
      for (int i = 0; i < images.length; i++) {
        byteData = await images[i].getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        List<int> compressedImageData = await testCompressList(imageData);
        String baseData = base64Encode(compressedImageData);
        allImages.putIfAbsent("$i", () => baseData);
      }
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
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: onProgress,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: NeumorphicAppBar(
          centerTitle: true,
          title: NeumorphicText('Post', textStyle: NeumorphicTextStyle(fontSize: 15), style: NeumorphicStyle(color: Theme.of(context).primaryColor),),
          actions: <Widget>[
            NeumorphicButton(
              child: Icon(Icons.camera),
              tooltip: "Add Media",
              onPressed: () {
                loadAssets();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(children: [
              Expanded(
                flex: 4,
                child: Neumorphic(
                  padding: EdgeInsets.all(15),
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.concave,
                  ),
                  child: TextField(
                    controller: bodyController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'What\'s Going On...!!!',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                flex: 2,
                child: images.length < 1
                    ? InkWell(
                        onTap: () {
                          loadAssets();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 150,
                          child: NeumorphicIcon(
                            Icons.add_circle,
                            size: 40,
                            //color: Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemExtent: 150,
                        itemBuilder: (context, item) {
                          return Card(
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: imagesList == null
                                  ? Container(
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator(),
                                    )
                                  : Stack(
                                      children: [
                                        Container(
                                            width: double.infinity,
                                            child: Image.memory(
                                              base64.decode(imagesList["$item"]),
                                              fit: BoxFit.cover,
                                            ),
                                        ),
//                                  Positioned(
//                                    top: 2,
//                                    right: 2,
//                                    child: IconButton(
//                                      icon: Icon(Icons.close),
//                                      onPressed: (){
//                                        setState(() {
//                                          images.removeAt(item);
//                                        });
//                                      },
//                                    ),
//                                  ),
                                      ],
                                    ),
                            ),
                          );
                        },
                        itemCount: images.length,
                      ),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 200,
                    height: 50,
                    child: NeumorphicButton(
                      style: NeumorphicStyle(
                        intensity: 20,
                        depth: 5,
                      ),
                      onPressed: () {
                        setState(() {
                          onProgress = true;
                        });
                        createPost(context);
                      },
                      child: Text(
                        'Post Now',
                        style: TextStyle(
                          //color: Colors.white,
                          fontSize: 20,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
