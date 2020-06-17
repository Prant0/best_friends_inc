import 'dart:convert';

import 'package:bestfriends/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Registation_Page extends StatefulWidget {
  static const routeName = '/registrationPage';
  @override
  _Registation_PageState createState() => _Registation_PageState();
}

class _Registation_PageState extends State<Registation_Page> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String _username, _password, _rePassword, _number;
  bool _obscureText = true;
  bool onProgress = false;
  String errorTxt;
  var url = "http://192.168.0.108/public/api/register";

  Future<String> _submit() async {
    //if (_formKey.currentState.validate()){
    final form = _formKey.currentState;
    if (form.validate()) {
      setState(() {
        onProgress = true;
      });
      form.save();
      final checkUser = await checkExistingUser(_number);
      if (!checkUser) {
        //TODO: Write OTP functions here
          var response = await http.post(url,
              headers: {
                'Accept':'application/json',
              },
              body: {
                'name': _username,
                'phone': _number,
                'password': _password,
                'verified':'0',
                'referral_id':'null',
              }
          );
          if(response.statusCode==200){
            return 'Success';
          }
          else{
            setState(() {
              onProgress = false;
            });
            return 'Something Wrong!';
          }
      }
      else {
        setState(() {
          onProgress = false;
        });
        return 'Phone number already registered';
      }
    }
    return 'Invalid Inputs';
}

  Future<bool> checkExistingUser(String number) async{
    var url = "http://192.168.0.108/public/api/check-user-exists/$number";
    var response = await http.get(url);
    if(int.parse(response.body)==1)
    return true;
    else if(int.parse(response.body)==0)
    return false;
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
                     height: 150,width: 200,
                     child: Image(
                       image: AssetImage('images/bf.png')
                     ),
                   ),
               Text('Register',style: TextStyle(fontSize: 42.0,fontWeight: FontWeight.w900,letterSpacing: 2),),
               Form(
                 key: _formKey,
                 child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0,vertical: 20.0),

                      child: TextFormField(
                        onSaved: (val)=>_username=val,
                        validator: (val)=>val.length<6 ? 'Username Too Short':null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          //  labelText: "Username",
                          hintText: 'Enter Full Name',
                          prefixIcon: Icon(Icons.face,color: Colors.teal),
                        ),
                      ),
                  ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0,vertical: 10.0),

                        child: TextFormField(
                          onSaved: (val)=>_number=val,
                          validator: (val)=>val.length!=11 ? 'Mobile number Invalid!':null,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            //  labelText: "Username",
                            hintText: 'Enter 11 Digits Mobile Number',
                            prefixIcon: Icon(Icons.phone,color: Colors.teal),
                          ),
                        ),


                    ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                          child: TextFormField(
                            onSaved: (val)=>_password=val,
                            obscureText: _obscureText,
                            validator: (val)=> val.length < 6 ? "Password is too short":null,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    _obscureText=!_obscureText;
                                  });
                                },
                                child: Icon(
                                  _obscureText?Icons.visibility:Icons.visibility_off,color: Colors.teal,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              // labelText: "Password",
                              hintText: 'Password',
                              prefixIcon: Icon(Icons.lock,color: Colors.teal,),
                              // icon: Icon(Icons.lock,color: Colors.teal,)

                            ),
                          ),

                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                          child: TextFormField(
                            onSaved: (val)=>_rePassword=val,
                            obscureText: _obscureText,
                            validator: (val)=> val!=_password ? "Password didn't matched":null,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    _obscureText=!_obscureText;
                                  });
                                },
                                child: Icon(
                                  _obscureText?Icons.visibility:Icons.visibility_off,color: Colors.teal,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              // labelText: "Password",
                              hintText: 'Confirm Password',
                              prefixIcon: Icon(Icons.lock,color: Colors.teal,),
                              // icon: Icon(Icons.lock,color: Colors.teal,)

                            ),
                          ),

                      ),

                 ]
               ),
            ),
          Padding(
            padding: EdgeInsets.only(top:20.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: 150.0,
                  child: Builder(
                    builder: (context)=> RaisedButton(
                      child: Text(
                        'Submit',style: TextStyle(color: Colors.white,fontSize: 20.0,),
                      ),color: Theme.of(context).primaryColor,
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                      onPressed: () async{
                        String subResult = await _submit();
                        if(subResult=='Success')
                          {
                            Navigator.of(context).pushNamed(Login_Page.routeName);
                          }
                        else
                          {
                            Scaffold.of(context).removeCurrentSnackBar();
                            Scaffold.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(subResult, style: TextStyle(
                                  color: Colors.white,
                                ),),
                              ),
                            ),
                            );
                          }
                      },
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: (){
                    Navigator.pushReplacementNamed(context, Login_Page.routeName);
                  },
                  child: RichText(
                    text: TextSpan(
                        text: " Existing User ?  ",
                        style: TextStyle(fontSize:16.0,color: Colors.black87,fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(text: 'Login',style: TextStyle(fontSize:15.0,color: Colors.red,))
                        ]
                    ),
                  )
                ),
                Container(
                  alignment: Alignment.center,
                  child: errorTxt==null?Container():Text(errorTxt),
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
