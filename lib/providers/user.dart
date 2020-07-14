import 'package:bestfriends/http/requests.dart';
import 'package:flutter/cupertino.dart';

class User {
  final int userId;
  final String name;
  final String phone;
  final int isVerified;
  final String profilePic;
  final String coverPic;
  final String gender;
  final String religion;
  final String hometown;
  final String livesIn;
  final String birthday;
  final String occupation;
  final String nickName;
  User({this.userId, this.name, this.phone, this.isVerified, this.coverPic, this.profilePic, this.gender, this.livesIn, this.occupation, this.nickName, this.religion, this.birthday, this.hometown});
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
        gender: user["gender"],
        livesIn: user["lives_in"],
        occupation: user["occupation: "],
        nickName: user["nick_name"],
        religion: user["religion"],
        birthday: user["birthday"].toString(),
        hometown: user["hometown"],
      );
    }
    notifyListeners();
    return _user;
  }
}
