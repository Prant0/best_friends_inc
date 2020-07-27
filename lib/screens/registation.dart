import 'package:bestfriends/api/googleApi.dart';
import 'package:bestfriends/http/requests.dart';
import 'package:bestfriends/screens/login.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Registation_Page extends StatefulWidget {
  static const routeName = '/registrationPage';
  @override
  _Registation_PageState createState() => _Registation_PageState();
}

class _Registation_PageState extends State<Registation_Page> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String _username, _password, _rePassword, _number, deviceId, _referralId = "";
  bool _obscureText = true;
  bool onProgress = false;
  String errorTxt;
  Future<String> _submit() async {
    //if (_formKey.currentState.validate()){
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        onProgress = true;
      });
      final checkUser = await CustomHttpRequests.checkExistingUser(_number,deviceId);
      if (!checkUser) {
        if (_referralId != "") {
          final referralCheck = await CustomHttpRequests.checkReferral(_referralId);
          if (!referralCheck) {
            setState(() {
              onProgress = false;
            });
            return "Invalid Referral ID";
          }
        }
        await GoogleApi.checkOtpSuccess(_number, context, _username, _password, _referralId, deviceId);
        setState(() {
          onProgress = false;
        });
      } else {
        setState(() {
          onProgress = false;
        });
        return 'Number|Device already registered';
      }
    } else {
      return 'Invalid Inputs';
    }
  }

  @override
  void initState() {
    FirebaseAuth.instance.signOut();
    super.initState();
  }

  @override
  void didChangeDependencies() async{
    deviceId = await _getId();
    print(deviceId);
    super.didChangeDependencies();
  }

  Future<String> _getId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: onProgress,
        dismissible: false,
        progressIndicator: CircularProgressIndicator(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: 150,
                width: 200,
                child: Image(image: AssetImage('images/bf.png')),
              ),
              NeumorphicText(
                'Register',
                textStyle: NeumorphicTextStyle(fontSize: 42.0, letterSpacing: 2, fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily),
                style: NeumorphicStyle(color: Theme.of(context).primaryColor),
              ),
              Form(
                key: _formKey,
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        depth: -5,
                      ),
                      child: TextFormField(
                        onSaved: (val) => _username = val,
                        validator: (val) => val.length < 6 ? 'Username Too Short' : null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          //  labelText: "Username",
                          hintText: 'John Doe',
                          labelText: 'Your Name',
                          prefixIcon: Icon(Icons.face, color: Theme.of(context).iconTheme.color),
                        ),
                        //maxLength: 30,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        depth: -5,
                      ),
                      child: TextFormField(
                        onSaved: (val) => _number = val,
                        validator: (val) => val.length != 11 ? 'Mobile number Invalid!' : null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "11 Digit Phone",
                          hintText: '01XXXXXXXXX',
                          prefixIcon: Icon(Icons.phone, color: Theme.of(context).iconTheme.color),
                        ),
                        keyboardType: TextInputType.numberWithOptions(),
                        //maxLength: 11,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        depth: -5,
                      ),
                      child: TextFormField(
                        onChanged: (val) => _password = val,
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
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                          border: InputBorder.none,
                          // labelText: "Password",
                          hintText: 'XXXXXX',
                          labelText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          // icon: Icon(Icons.lock,color: Colors.teal,)
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        depth: -5,
                      ),
                      child: TextFormField(
                        onChanged: (val) => _rePassword = val,
                        obscureText: _obscureText,
                        validator: (val) => val != _password ? "Password didn't matched" : null,
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              _obscureText ? Icons.visibility : Icons.visibility_off,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                          border: InputBorder.none,
                          // labelText: "Password",
                          hintText: 'XXXXXX',
                          labelText: 'Re-type Password',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          // icon: Icon(Icons.lock,color: Colors.teal,)
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        depth: -5,
                      ),
                      child: TextFormField(
                        onChanged: (val) => _referralId = val,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          // labelText: "Password",
                          hintText: '0123456789XX',
                          labelText: 'Introducer A/C NO. (Optional)',
                          prefixIcon: Icon(
                            Icons.attach_money,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          // icon: Icon(Icons.lock,color: Colors.teal,)
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 150.0,
                      child: Builder(
                        builder: (context) => NeumorphicButton(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          style: NeumorphicStyle(
                           //color: Theme.of(context).primaryColor,
                            intensity: 30,
                          ),
//                          color: Theme.of(context).primaryColor,
//                          elevation: 10.0,
//                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                          onPressed: () async {
                            String subResult = await _submit();
                            if (subResult == 'Success') {
                              Navigator.of(context).pushNamed(Login_Page.routeName);
                            } else if (subResult == null) {
                              return;
                            } else {
                              Scaffold.of(context).removeCurrentSnackBar();
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      subResult,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    NeumorphicButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, Login_Page.routeName);
                      },
                      child: NeumorphicText("Login Here", style: NeumorphicStyle(
                        color: Theme.of(context).primaryColor,
                      ),),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: errorTxt == null ? Container() : Text(errorTxt),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
