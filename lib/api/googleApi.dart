import 'package:bestfriends/http/requests.dart';
import 'package:bestfriends/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleApi {
  static String verificationId, smsCode;
  static SharedPreferences sharedPreferences;
  static Future<bool> checkOtpSuccess(String number, BuildContext context, String username, String password, String referralId, String deviceId) async {
    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {
      verificationId = verId;
    };

    final PhoneCodeSent phoneCodeSent = (String verId, [int forceCodeSent]) {
      verificationId = verId;
      //smsCodeDialogue(context);
    };

    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential credential) {
      print(credential.providerId);
    };

    final PhoneVerificationFailed verificationFailed = (AuthException e) {
      print('${e.message}');
    };

    return FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: '+88$number',
      timeout: const Duration(seconds: 5),
      verificationCompleted: verifiedSuccess,
      verificationFailed: verificationFailed,
      codeSent: phoneCodeSent,
      codeAutoRetrievalTimeout: autoRetrievalTimeout,
    )
        .then((value) async {
      final smsResponse = await smsCodeDialogue(context, number, username, password, referralId, deviceId);
      return smsResponse;
    }).catchError((e) {
      print('Execution Failed');
      return false;
    });
  }

  static Future<bool> smsCodeDialogue(BuildContext context, String number, String username, String password, String referralId, String deviceId) async {
    String errorMsg;
    Color warningColor = Colors.black;
    bool onProgress = false;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return ModalProgressHUD(
              inAsyncCall: onProgress,
              child: Neumorphic(
                child: AlertDialog(
                  title: errorMsg == null ? Text('Enter OTP Here', style: TextStyle(fontSize: 15, color: warningColor),) : Text(errorMsg,style: TextStyle(fontSize: 15, color: warningColor),),
                  content: Neumorphic(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.concave,
                    ),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      onChanged: (value) {
                        if(value.length<7)
                        smsCode = value;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  contentPadding: EdgeInsets.all(20),
                  actions: <Widget>[
                    NeumorphicButton(
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        intensity: 20,
                      ),
                      margin: EdgeInsets.only(right: 15),
                      child: Text('Submit'),
                      onPressed: () async {
                        setState(() {
                          onProgress = true;
                        });
                        final codeRes = await signInUser(context);
                        print(codeRes);
                        if (codeRes != "Wrong OTP") {
                          final regRes = await CustomHttpRequests.registerUser(number,username,password,referralId,codeRes, deviceId);
                          if(regRes)
                            {
                              sharedPreferences = await SharedPreferences.getInstance();
                              sharedPreferences.setString("userPhone", number);
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacementNamed(Login_Page.routeName);
                            }
                          else
                            {
                              setState(() {
                                errorMsg = "Something Wrong";
                                onProgress = false;
                              });
                            }
                        } else {
                          setState(() {
                            errorMsg = codeRes;
                            warningColor = Colors.red;
                            onProgress = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Future<String> signInUser(BuildContext context) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final matchOTPRes = FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      return user.user.uid;
    }).catchError((e) {
      return 'Wrong OTP';
    });
    return matchOTPRes;
  }
}
