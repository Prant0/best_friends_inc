import 'dart:convert';

import 'package:bestfriends/http/requests.dart';
import 'package:bestfriends/screens/homepage.dart';
import 'package:bestfriends/screens/registation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login_Page extends StatefulWidget {
  static const routeName = '/loginPage';
  @override
  _Login_PageState createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  SharedPreferences sharedPreferences;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String _phone, _password;
  bool _obscureText = true;
  bool onProgress = false;
  String phoneNum;
  TextEditingController numberController = TextEditingController();

  @override
  void initState() {
    checkPhoneNumber();
    checkLoginStatus();
    //pushData();
    super.initState();
  }

//  void pushData(){
//    var options = PusherOptions(auth: PusherAuth("endpoint",), host: 'http://110/laravel.test/public', port: 6001, encrypted: false, cluster: 'ap1');
//    FlutterPusher pusher = FlutterPusher('app', options, enableLogging: true);
//
//    Echo echo = new Echo({
//      'broadcaster': 'pusher',
//      'client': pusher,
//      'key': '3b28be7ee30357cd7727',
//      'cluster': 'ap1',
//      'PUSHER_APP_ID': '1043039',
//    });
//
//    echo.channel('my-channel').listen('my-event', (e) {
//      print(e);
//    });
//
////    echo.socket.on('connect', (_) => print('connect'));
////    echo.socket.on('disconnect', (_) => print('disconnect'));
//  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    }
  }



  checkPhoneNumber()async{
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      phoneNum = sharedPreferences.getString("userPhone");
      numberController.text = phoneNum;
    });
  }

  Future<String> _submit() async {
    //if (_formKey.currentState.validate()){
    setState(() {
      onProgress = true;
    });
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (await validationProcess()) {
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
        return "Logged In";
      } else {
        setState(() {
          onProgress = false;
        });
        return "Incorrect Credentials";
      }
    } else {
      setState(() {
        onProgress = false;
      });
      return "Validation Error";
    }
  }

  Future<bool> validationProcess() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      final result = await CustomHttpRequests.login(_phone, _password);
      final data = jsonDecode(result);
      if(data["access_token"]!=null)
        {
          sharedPreferences.setString("token", data['access_token']);
          final userData = await CustomHttpRequests.me();
          setState(() {
            sharedPreferences.setString("userId", userData["id"].toString());
            sharedPreferences.setString("name", userData["name"]);
            sharedPreferences.setString("userPhone", userData["phone"]);
            sharedPreferences.setString("profile_pic", userData["profile_pic"]);
          });
          return true;
        }
      else{
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: onProgress,
        child: Container(
          padding: EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 45.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 5.0),
                    child: Image(
                        image: AssetImage('images/bf.png'),
                    ),
                  ),
                  NeumorphicText(
                    'Login',
                    textStyle: NeumorphicTextStyle(fontSize: 42.0, letterSpacing: 2,),
                    style: NeumorphicStyle(color: Theme.of(context).primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                        depth: -5,
                      ),
                      child: TextFormField(
                        controller: numberController,
                        readOnly: phoneNum!=null,
                        onSaved: (val) => _phone = val,
                        validator: (val) => val.length < 6 ? 'Username Too Short' : null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          //  labelText: "Username",
                          hintText: '01XXXXXXXXX', hintStyle: TextStyle(fontSize: 14.0),
                          labelText: '11 Digits phone',
                          prefixIcon: Icon(Icons.face, color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        depth: -5,
                        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                      ),
                      child: TextFormField(
                        onSaved: (val) => _password = val,
                        obscureText: _obscureText,
                        validator: (val) => val.length < 6 ? "Password is too short" : null,
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              _obscureText ? Icons.visibility : Icons.visibility_off,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          border: InputBorder.none,
                          // labelText: "Password",
                          hintText: 'XXXXXX', hintStyle: TextStyle(fontSize: 15.0),
                          labelText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).primaryColor,
                          ),
                          // icon: Icon(Icons.lock,color: Colors.teal,)
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 120.0,
                          height: 45.0,
                          child: NeumorphicButton(
                              child: Text(
                                'Login',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20.0,
                                ),
                              ),
                              style: NeumorphicStyle(
                                intensity: 30.0,
                                //color: Colors.tealAccent,
//                                elevation: 15.0,
//                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                              ),
                              onPressed: () async {
                                final response = await _submit();
                                if (response != null) {
                                  _scaffoldKey.currentState.removeCurrentSnackBar();
                                  _scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: Text(
                                          response,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        NeumorphicButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, Registation_Page.routeName);
                          },
                          child: NeumorphicText("Registration Here", style: NeumorphicStyle(
                            color: Theme.of(context).primaryColor,
                          ),),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
