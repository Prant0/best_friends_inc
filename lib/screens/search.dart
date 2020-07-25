import 'package:bestfriends/http/requests.dart';
import 'package:bestfriends/widgets/searchResults.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SearchPage extends StatefulWidget {
  static const String routeName = "/SearchPage";
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();
  List<dynamic> results = [];
  String infoTxt = "No Data Found";

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeumorphicAppBar(
        title: Neumorphic(
          style: NeumorphicStyle(
            shape: NeumorphicShape.concave,
          ),
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: TextFormField(
            controller: searchController,
            cursorColor: Colors.white,
            autofocus: true,
            style: TextStyle(
              color: Color(0xFF0D1C40),
            ),
            decoration: InputDecoration(
              hintText: "Phone or Name",
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: Color(0xA00D1C40),
              ),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            enableFeedback: isLoading,
            icon: Icon(Icons.search),
            onPressed: isLoading
                ? null
                : () async {
                        setState(() {
                          isLoading = true;
                        });
                        results = await CustomHttpRequests.searchUsers(searchController.text);
                        setState(() {
                          if (results.length == 0) infoTxt = "No Data Found";
                          searchController.clear();
                          isLoading = false;
                        });
                      },
          )
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: results.length < 1
            ? Container(
                alignment: Alignment.center,
                child: Text(infoTxt),
              )
            : ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  return SingleResult(
                    userId: results[index]["id"],
                    userIsVerified: results[index]["verified"] == 1 ? true : false,
                    userName: results[index]["name"],
                    userProfilePic: results[index]["profile_pic"],
                  );
                },
              ),
      ),
    );
  }
}
