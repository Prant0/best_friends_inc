
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class PostStatus extends StatefulWidget {
  static const String routeName = '/postStatusScreen';

  @override
  _PostStatusState createState() => _PostStatusState();
}

class _PostStatusState extends State<PostStatus> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                flex: 1,
                child: images==null?Container():ListView.builder(
                  scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemExtent: 100,
                    itemBuilder: (context, item){
                      return Card(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: AssetThumb(
                            asset: images[item],
                            height: 100,
                            width: 100,
                          ),
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
                      onPressed: (){},
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
    );
  }
}
