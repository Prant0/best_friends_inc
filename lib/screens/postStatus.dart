
import 'dart:convert';
import 'dart:typed_data';

import 'package:bestfriends/http/requests.dart';
import 'package:bestfriends/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class PostStatus extends StatefulWidget {
  static const String routeName = '/postStatusScreen';

  @override
  _PostStatusState createState() => _PostStatusState();
}

class _PostStatusState extends State<PostStatus> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String body, errorMsg;
  bool onProgress=false;
  var imagesList;
  List<Asset> images = List<Asset>();
  Map<String, String> allImages = {};
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

    setState((){
      images = resultList;
    });

    imagesList = await formatImages();
    setState(() {
    });

  }

  createPost(BuildContext context)async{
    //TODO: Check Error Handling on Post Upload
    final postRequest = await CustomHttpRequests.createPost(body, imagesList);
    setState(() {
      onProgress = false;
      errorMsg = postRequest["message"].toString();
      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(errorMsg),
        ),
      );
    });
  }

  Future<Map<String, String>> formatImages()async{
    ByteData byteData;
    if(images.length>0)
    {
      print(images);
      for(int i=0; i<images.length; i++){
        byteData = await images[i].getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        String baseData = base64Encode(imageData);
        allImages.putIfAbsent("$i", () => baseData);
      }
    }
    return allImages;
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
              onPressed: (){
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
            child: Column(
              children:[
                Expanded(
                  flex: 4,
                  child: TextField(
                    onChanged: (val)=>body=val,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'What\'s Going On...!!!',
                      border: OutlineInputBorder(
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: images==null?Container():ListView.builder(
                    scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemExtent: 150,
                      itemBuilder: (context, item){
                        return Card(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: allImages.isEmpty?Container():Image.memory(base64.decode(allImages["$item"]), fit: BoxFit.cover,),
                          ),
                        );
                      },
                    itemCount: images.length,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: 200,
                      height: 50,
                      child: RaisedButton(
                        onPressed: (){
                          setState(() {
                            onProgress = true;
                          });
                          createPost(context);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        color: Theme.of(context).primaryColor,
                        child: Text('Post Now', style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          letterSpacing: 1,
                        ),),
                      ),
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}
