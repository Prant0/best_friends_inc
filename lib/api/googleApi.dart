
import 'package:bestfriends/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GoogleApi {
  static String verificationId, smsCode;
  static Future<bool> checkOtpSuccess(String number, BuildContext context) async{
    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId){
      verificationId = verId;
    };

    final PhoneCodeSent phoneCodeSent = (String verId, [int forceCodeSent]){
      verificationId = verId;
      //smsCodeDialogue(context);
    };

    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential credential){
      print(credential.providerId);
    };

    final PhoneVerificationFailed verificationFailed = (AuthException e){
      print('${e.message}');
    };

    return FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verifiedSuccess,
      verificationFailed: verificationFailed,
      codeSent: phoneCodeSent,
      codeAutoRetrievalTimeout: autoRetrievalTimeout,
    ).then((value){
    print('Executed');
    return true;
    }).catchError((e){
    print('Executed Failed');
    return false;
    });
  }

  static Future<bool> smsCodeDialogue(BuildContext context){
    return showDialog(context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Enter OTP Here'),
          content: TextField(
            onChanged: (value){
              smsCode = value;
            },
          ),
          contentPadding: EdgeInsets.all(20),
          actions: <Widget>[
            FlatButton(
              child: Text('Submit'),
              onPressed: ()async{
                Navigator.of(context).pop();
                return await signInUser(context);
              },
            ),
          ],
        );
      },
    );
  }


static Future<bool> signInUser(BuildContext context) async{
  final AuthCredential credential = PhoneAuthProvider.getCredential(
    verificationId: verificationId,
    smsCode: smsCode,
    );
    return FirebaseAuth.instance.signInWithCredential(credential).then((user){
      //Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      return true;
    }).catchError((e){
      print('Error check, $e');
      return false;
    });
  }
}