import 'dart:convert';

import 'package:bestfriends/http/requests.dart';
import 'package:bestfriends/screens/homepage.dart';
import 'package:bestfriends/screens/registation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    checkLoginStatus();
    super.initState();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    }
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
      setState(() {
        sharedPreferences.setString("token", data['access_token']);
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                    child: TextFormField(
                      onSaved: (val) => _phone = val,
                      validator: (val) => val.length < 6 ? 'Username Too Short' : null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        //  labelText: "Username",
                        hintText: '01XXXXXXXXX', hintStyle: TextStyle(fontSize: 14.0),
                        labelText: '11 Digits phone',
                        prefixIcon: Icon(Icons.face, color: Colors.teal),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
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
                            color: Colors.teal,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        // labelText: "Password",
                        hintText: 'XXXXXX', hintStyle: TextStyle(fontSize: 15.0),
                        labelText: 'Password',
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.teal,
                        ),
                        // icon: Icon(Icons.lock,color: Colors.teal,)
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
                          child: RaisedButton(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                              color: Theme.of(context).primaryColor,
                              elevation: 15.0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
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
                        FlatButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, Registation_Page.routeName);
                          },
                          child: RichText(
                            text: TextSpan(
                                text: " New user ?  ",
                                style: TextStyle(fontSize: 16.0, color: Colors.black87, fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                      text: 'Registation here',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.red,
                                      ))
                                ]),
                          ),
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
