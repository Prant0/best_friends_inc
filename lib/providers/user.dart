import 'package:bestfriends/http/requests.dart';
import 'package:flutter/cupertino.dart';

class User {
  final int userId;
  final String name;
  final String phone;
  final int isVerified;
  final String profilePic;
  final String coverPic;
  User({this.userId, this.name, this.phone, this.isVerified, this.coverPic, this.profilePic});
}

class Users with ChangeNotifier {
  User _user;

  Future<dynamic> getUser(int userId) async {
    final user = await CustomHttpRequests.userInfo(userId);
    if (user == "Error")
      return "Error";
    else {
      _user = User(
        userId: user["id"],
        name: user["name"],
        phone: user["phone"],
        isVerified: user["verified"],
        profilePic: user["profile_pic"],
        coverPic: user["cover_pic"],
      );
    }
    notifyListeners();
    return _user;
  }
}
