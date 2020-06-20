import 'package:bestfriends/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class GoogleApi {
  static String verificationId, smsCode;
  static Future<bool> checkOtpSuccess(String number, BuildContext context) async {
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
      phoneNumber: number,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verifiedSuccess,
      verificationFailed: verificationFailed,
      codeSent: phoneCodeSent,
      codeAutoRetrievalTimeout: autoRetrievalTimeout,
    )
        .then((value) async {
      final smsResponse = await smsCodeDialogue(context);
      return smsResponse;
    }).catchError((e) {
      print('Executed Failed');
      return false;
    });
  }

  static Future<bool> smsCodeDialogue(BuildContext context) async {
    String errorMsg;
    bool onProgress = false;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return ModalProgressHUD(
              inAsyncCall: onProgress,
              child: AlertDialog(
                title: errorMsg == null ? Text('Enter OTP Here') : Text(errorMsg),
                content: TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  onChanged: (value) {
                    smsCode = value;
                  },
                ),
                contentPadding: EdgeInsets.all(20),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Submit'),
                    onPressed: () async {
                      setState(() {
                        onProgress = true;
                      });
                      final codeRes = await signInUser(context);
                      print(codeRes);
                      if (codeRes == "Done") {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed(Login_Page.routeName);
                      } else {
                        setState(() {
                          errorMsg = codeRes;
                          onProgress = false;
                        });
                      }
                    },
                  ),
                ],
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
      return 'Done';
    }).catchError((e) {
      return 'Wrong OTP';
    });
    return matchOTPRes;
  }
}
