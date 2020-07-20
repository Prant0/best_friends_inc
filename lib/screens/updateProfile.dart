import 'dart:convert';

import 'package:bestfriends/http/requests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfile extends StatefulWidget {
  static const routeName = '/update_profile';
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _init=true, _processing=false;
  Map<String, dynamic> userData;
  final nickName = TextEditingController();
  final occupation = TextEditingController();
  final livesIn = TextEditingController();
  final homeTown = TextEditingController();
  final birthDay = TextEditingController();
  SharedPreferences sharedPreferences;
  String profilePic, coverPic;
  final List<String> gender = ["Male","Female","Other"];
  String _selectedGender;
  final List<String> religion = ["Islam","Hindu","Other"];
  String _selectedReligion;
  @override
  didChangeDependencies()async{
    if(_init)
      {
        userData = await CustomHttpRequests.me();
        setState(() {
          profilePic = userData["profile_pic"];
          coverPic = userData["cover_pic"];
          userData["nick_name"]==null? nickName.text="Ready to Add": nickName.text = userData["nick_name"];
          userData["occupation"]==null? occupation.text="Ready to Add":occupation.text = userData["occupation"];
          userData["lives_in"]==null? livesIn.text="Ready to Add":livesIn.text = userData["lives_in"];
          userData["hometown"]==null? homeTown.text="Ready to Add":homeTown.text = userData["hometown"];
          userData["birthday"]==null? birthDay.text="Ready to Add":birthDay.text = userData["birthday"];
          userData["religion"]==null? _selectedReligion="Other":_selectedReligion = userData["religion"];
          userData["gender"]==null? _selectedGender="Other":_selectedGender = userData["gender"];
          _init = false;
        });
      }
    super.didChangeDependencies();
  }

  List<Asset> images = List<Asset>();
  Future<void> loadProfilePic() async {
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

    profilePic = await formatImages();
    setState(() {
      images = List<Asset>();
    });
  }

  Future<void> loadCoverPic() async {
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

    coverPic = await formatImages();
    setState(() {
      images = List<Asset>();
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

  Future<String> requestUpdate()async{
    String msg;
    try{
      await CustomHttpRequests.updateProfile("nick_name", nickName.text);
      await CustomHttpRequests.updateProfile("occupation", occupation.text);
      await CustomHttpRequests.updateProfile("lives_in", livesIn.text);
      await CustomHttpRequests.updateProfile("hometown", homeTown.text);
      await CustomHttpRequests.updateProfile("birthday", birthDay.text);
      await CustomHttpRequests.updateProfile("gender", _selectedGender);
      await CustomHttpRequests.updateProfile("religion", _selectedReligion);
      await CustomHttpRequests.updateProfile("profile_pic", profilePic);
      await CustomHttpRequests.updateProfile("cover_pic", coverPic);
      sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString("profile_pic", profilePic);
      msg = "Updated Successfully";
    }catch(e){
      print(e.toString());
      msg = "Failed";
    }
    return msg;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Update Information"),
      ),
      body: userData==null?Container(alignment: Alignment.center, child: CircularProgressIndicator(),): _processing==false?SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        loadProfilePic();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.memory(
                          base64.decode(profilePic),
                          fit: BoxFit.cover,
                          height: 150,
                          width: 35,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        loadCoverPic();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          base64.decode(coverPic),
                          fit: BoxFit.cover,
                          height: 150,
                          width: 35,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: 15
              ),
              UpdateTextField(cont: nickName, label: "Nick Name", readOnly: false, maxLength: 20,),
              SizedBox(
                height: 15
              ),
              UpdateTextField(cont: occupation, label: "Occupation", readOnly: false, maxLength: 20,),
              SizedBox(
                  height: 15
              ),
              UpdateTextField(cont: livesIn, label: "Lives In", readOnly: false, maxLength: 20,),
              SizedBox(
                  height: 15
              ),
              UpdateTextField(cont: homeTown, label: "Hometown", readOnly: false, maxLength: 20,),
              SizedBox(
                  height: 15
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 9,
                    child: UpdateTextField(cont: birthDay, label: "Birthday dd-mm-yyyy", readOnly: true,),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: ()async{
                        DateTime bDay = await showRoundedDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950, 1, 1),
                          lastDate: DateTime.now(),
                          borderRadius: 16,
                          theme: ThemeData.dark(),
                        );
                        birthDay.text = "${bDay.year.toString()}-${bDay.month.toString()}-${bDay.day.toString()}";
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: 15
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: DropdownButton(
                        value: _selectedGender,
                        items: gender.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (val){
                          setState(() {
                            _selectedGender = val;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: DropdownButton(
                        value: _selectedReligion,
                        items: religion.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (val){
                          setState(() {
                            _selectedReligion = val;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: 15
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text("UPDATE", style: TextStyle(
                    color: Colors.white,
                  ),),
                  onPressed: ()async{
                    setState(() {
                      _processing = true;
                    });
                    String result = await requestUpdate();
                    setState(() {
                      _processing = false;
                    });
                    _scaffoldKey.currentState.removeCurrentSnackBar();
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            result,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ):Container(alignment: Alignment.center, child: CircularProgressIndicator(),),
    );
  }
}

class UpdateTextField extends StatelessWidget {
  final TextEditingController cont;
  final String label;
  final bool readOnly;
  final int maxLength;

  UpdateTextField({this.cont, this.label, this.readOnly, this.maxLength});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: cont,
      readOnly: readOnly,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      onEditingComplete: (){
        print(cont.text);
      },
    );
  }
}
