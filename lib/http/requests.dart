import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class CustomHttpRequests{
  static const String uri = "http://192.168.0.108/public/api";
  static SharedPreferences sharedPreferences;

  static const Map<String, String> defaultHeader = {
  "Accept":"application/json",
  };

  static Future<Map<String, String>> getHeaderWithToken()async{
    sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Accept":"application/json",
      "Authorization":"bearer ${sharedPreferences.getString('token')}",
    };
    return header;
  }


  //Takes phone number and checks if the user exists
  static Future<bool> checkExistingUser(String number) async{
    var url = "$uri/check_user_exists/$number";
    var response = await http.get(url,
      headers: defaultHeader,
    );
    if(response.body=="found")
      {
        return true;
      }
    else if(response.body=="not-found")
      {
        return false;
      }
    return false;
  }

  //Takes Referral ID and checks if the Referrer exists
  static Future<bool> checkReferral(String referralId) async{
    var url = "$uri/check_valid_ref_id/$referralId";
    var response = await http.get(url,
      headers: defaultHeader,
    );
    if(response.body=="found")
    {
      return true;
    }
    else if(response.body=="not-found")
    {
      return false;
    }
    return false;
  }

  //Takes phone and password for logging in users
  static Future<String> login (String phone, String password)async{
    try{
      final url = '$uri/login';
      var response = await http.post(url,
          headers: defaultHeader,
          body: {
            'phone': phone,
            'password': password,
          }
      );
      if(response.statusCode==200)
      {
        return response.body;
      }
      else
      {
        throw('Error: Something wrong');
      }
    }
    catch(e){
      return e.toString();
    }
  }

  //Logout, and expire token
  static Future<bool> logout()async{
    try
    {
      final url = '$uri/logout';
      var response = await http.post(url,
        headers: await getHeaderWithToken(),
      );
      if(response.statusCode==200)
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    catch(e){
      return false;
    }
  }

  //Returns user, using for debugging
  static Future<String> me (String token)async{
    try{
      final url = '$uri/me';
      var response = await http.get(url,
        headers: {
          "Authorization":"bearer $token",
        }
      );
      if(response.statusCode==200)
      {
        return response.body;
      }
      else
      {
        throw('Error: Something wrong ${response.statusCode}');
      }
    }
    catch(e){
      return e.toString();
    }
  }

  //Registering a user after unique validation and OTP check
  static Future<bool> registerUser(String phone, String username, String password, String referralId, String fid)async{
    ByteData bytes = await rootBundle.load('images/avatar.jpg');
    var buffer = bytes.buffer.asUint8List();
    var profilePic = base64.encode(buffer);
    ByteData bytesCover = await rootBundle.load('images/cover.jpg');
    var bufferCover = bytesCover.buffer.asUint8List();
    var coverPic = base64.encode(bufferCover);
    try{
      var response = await http.post("$uri/register",
          headers: defaultHeader,
          body: {
            'name': username,
            'phone': phone,
            'password': password,
            'referral_id': referralId.toString(),
            'fuuid': fid.toString(),
            'profile_pic': profilePic,
            'cover_pic': coverPic,
          }
      );
      if(response.statusCode==200){
        return true;
      }
      else{
        print("Status Code error ${response.statusCode} ${response.body}");
        return false;
      }
    }catch(e){
      print(e);
      return false;
    }
  }

  //Create A New Post
  static Future<dynamic> createPost(String body, var media)async{
    print(media.runtimeType);
    try{
      var response = await http.post("$uri/post",
          headers: await getHeaderWithToken(),
          body: {
            'body': body==null?"":body,
            'media': media==null||media=="null"?"":jsonEncode(media),
          }
      );
      final data = jsonDecode(response.body);
      if(response.statusCode==200 || response.statusCode==201){
        return data;
      }
      else{
        print("Status Code error ${response.statusCode} ${response.body}");
        return data;
      }
    }catch(e){
      print(e);
      return "Something Wrong...!!!";
    }
  }
}