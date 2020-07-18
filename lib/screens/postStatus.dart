import 'dart:convert';
import 'dart:typed_data';

import 'package:bestfriends/http/requests.dart';
import 'package:bestfriends/providers/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

//TODO: Redirect to homepage when post completed or Clear PostStatus Page


class PostStatus extends StatefulWidget {
  static const String routeName = '/postStatusScreen';

  @override
  _PostStatusState createState() => _PostStatusState();
}

class _PostStatusState extends State<PostStatus> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
    final Map<String, dynamic> postRequest = await CustomHttpRequests.createPost(body, imagesList);
    if (postRequest["message"].toString() == "Success") {
      responseMsg = "Success";
      Provider.of<Posts>(context, listen: false).createPost(postRequest);
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
        appBar: AppBar(
          centerTitle: true,
          title: Text('Post'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.camera),
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
                child: TextField(
                  onChanged: (val) => body = val,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'What\'s Going On...!!!',
                    border: OutlineInputBorder(),
                  ),
                ),
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
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Theme.of(context).primaryColor,
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
                                            )),
//                                  Positioned(
//                                    top: 2,
//                                    right: 2,
//                                    child: IconButton(
//                                      icon: Icon(Icons.close),
//                                      onPressed: (){
//                                        setState(() {
//                                          //TODO: Images removing only from last, Need Fix.
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
                height: 20,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 200,
                    height: 50,
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          onProgress = true;
                        });
                        createPost(context);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Post Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          letterSpacing: 1,
                        ),
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
