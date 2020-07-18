import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomHttpRequests {
  static const String uri = "http://192.168.0.109/bf.demo/public/api";
  static SharedPreferences sharedPreferences;

  static const Map<String, String> defaultHeader = {
    "Accept": "application/json",
  };

  static Future<Map<String, String>> getHeaderWithToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Accept": "application/json",
      "Authorization": "bearer ${sharedPreferences.getString('token')}",
    };
    print(sharedPreferences.getString('token'));
    return header;
  }

  //Takes phone number and checks if the user exists
  static Future<bool> checkExistingUser(String number) async {
    var url = "$uri/check_user_exists/$number";
    var response = await http.get(
      url,
      headers: defaultHeader,
    );
    if (response.body == "found") {
      return true;
    } else if (response.body == "not-found") {
      return false;
    }
    return false;
  }

  //Takes Referral ID and checks if the Referrer exists
  static Future<bool> checkReferral(String referralId) async {
    var url = "$uri/check_valid_ref_id/$referralId";
    var response = await http.get(
      url,
      headers: defaultHeader,
    );
    if (response.body == "found") {
      return true;
    } else if (response.body == "not-found") {
      return false;
    }
    return false;
  }

  //Takes phone and password for logging in users
  static Future<String> login(String phone, String password) async {
    try {
      final url = '$uri/login';
      var response = await http.post(url, headers: defaultHeader, body: {
        'phone': phone,
        'password': password,
      });
      if (response.statusCode == 200) {
        return response.body;
      }
      return "Something Wrong";
    } catch (e) {
      return e.toString();
    }
  }

  //Logout, and expire token
  static Future<bool> logout() async {
    try {
      final url = '$uri/logout';
      var response = await http.post(
        url,
        headers: await getHeaderWithToken(),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  //Returns user, using for debugging
  static Future<Map<String,dynamic>> me() async {
    try {
      final url = '$uri/get_auth_user';
      var response = await http.get(url, headers: await getHeaderWithToken(),);
      Map<String,dynamic> data = json.decode(response.body);
      if (response.statusCode == 200) {
        return data;
      } else {
        throw ('Error: Something wrong ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
      return {"error": e.toString()};
    }
  }

  //Registering a user after unique validation and OTP check
  static Future<bool> registerUser(String phone, String username, String password, String referralId, String fid) async {
    ByteData bytes = await rootBundle.load('images/avatar.jpg');
    var buffer = bytes.buffer.asUint8List();
    var profilePic = base64.encode(buffer);
    ByteData bytesCover = await rootBundle.load('images/cover.jpg');
    var bufferCover = bytesCover.buffer.asUint8List();
    var coverPic = base64.encode(bufferCover);
    try {
      var response = await http.post("$uri/register", headers: defaultHeader, body: {
        'name': username,
        'phone': phone,
        'password': password,
        'referral_id': referralId.toString(),
        'fuuid': fid.toString(),
        'profile_pic': profilePic,
        'cover_pic': coverPic,
      });
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Status Code error ${response.statusCode} ${response.body}");
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  //Create A New Post
  static Future<dynamic> createPost(String body, var media) async {
    try {
      var response = await http.post("$uri/post", headers: await getHeaderWithToken(), body: {
        'body': body == null ? "" : body,
        'media': media == null || media == "null" ? "" : jsonEncode(media),
      });
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return data;
      } else {
        print("Status Code error ${response.statusCode} ${response.body}");
        return data;
      }
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  //Update Post
  static Future<dynamic> updatePost(String body, var media, int postId) async {
    try {
      var response = await http.patch("$uri/post/$postId", headers: await getHeaderWithToken(), body: {
        'body': body == null ? "" : body,
        'media': media == null || media == "null" ? "" : jsonEncode(media),
      });
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return data;
      } else {
        print("Status Code error ${response.statusCode} ${response.body}");
        return data;
      }
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  //Create A New Comment
  static Future<dynamic> createComment(String body, int postId) async {
    try {
      var response = await http.post("$uri/comment/$postId", headers: await getHeaderWithToken(), body: {
        'body': body == null ? "" : body,
        'media': "",
      });
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return data;
      } else {
        print("Status Code error ${response.statusCode} ${response.body}");
        return data;
      }
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  //Get Profile Comments
  static Future<dynamic> userInfo(int userId) async {
    try {
      var response = await http.get(
        "$uri/user/profile/$userId",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200)
        return data;
      else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  //Get Profile Comments
  static Future<dynamic> getProfileComments(int postId) async {
    try {
      var response = await http.get(
        "$uri/comment/$postId",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200)
        return data;
      else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  //Update User Profile
  static Future<dynamic> updateProfile(String field, String newData) async {
    try {
      var response = await http.patch(
        "$uri/user/profile?update=$field",
        headers: await getHeaderWithToken(),
        body: {
          "value" : "$newData",
        },
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200)
        return data;
      else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  //Get User Posts
  static Future<dynamic> userPosts(int userId, int page) async {
    try {
      var response = await http.get(
        "$uri/post/user/$userId?page=${page.toString()}",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200)
        return data;
      else
        return {"error": "Could not load data"};
    } catch (e) {
      print(e);
      return {"error": "Something Wrong"};
    }
  }

  //Search Users
  static Future<dynamic> searchUsers(String keyword) async {
    try {
      var response = await http.get(
        "$uri/user/s?q=$keyword",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200)
        return data["data"];
      else
        return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  //Toggle Follow Someone
  static Future<dynamic> followUser(int uid) async {
    try {
      var response = await http.post(
        "$uri/user/toggle_follow/$uid",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200)
        return data;
      else
        return {"error": "Something Wrong"};
    } catch (e) {
      print(e);
      return {"error": "Something Wrong"};
    }
  }


  //Toggle Like Post
  static Future<dynamic> likePost(int postId) async {
    try {
      var response = await http.post(
        "$uri/post/toggle_like/$postId",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200)
        return data;
      else
        return {"error": "Something Wrong"};
    } catch (e) {
      print(e);
      return {"error": "Something Wrong"};
    }
  }


  //Fetch Timeline
  static Future<dynamic> timelinePosts(int call, int postCounts) async {
    try {
      var response = await http.post(
        "$uri/user/timeline",
        headers: await getHeaderWithToken(),
        body: {
          "call": call.toString(),
          "total_product_shown": postCounts.toString(),
        },
      );
      final data = jsonDecode(response.body);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200)
        return data;
      else
        return {"error": "Something Wrong"};
    } catch (e) {
      print(e);
      return {"error": "Something Wrong"};
    }
  }

  //Get Single Post
  static Future<dynamic> getOnePost(int postId) async {
    try {
      var response = await http.post(
        "$uri/post/$postId",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);
      print(response.statusCode);
      if (response.statusCode == 200)
        return data;
      else
        return {"error": "Something Wrong"};
    } catch (e) {
      print(e);
      return {"error": "Something Wrong"};
    }
  }


}
