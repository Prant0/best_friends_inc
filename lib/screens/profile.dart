import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final profileId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image(
                                image: AssetImage(
                                  'images/11.jpg',
                                ),
                                fit: BoxFit.cover,
                                width: 35,
                                height: 35,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Text("Al-Amin Hossain",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        background: Stack(
                          children: <Widget>[
                            Container(
                              height: double.infinity,
                                child: Image.asset('images/1.jpg', fit: BoxFit.cover,)),
                            Container(
                              width: double.infinity,
                              color: Colors.black45,
                            ),
                          ],
                        ),
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.person_add),
                        tooltip: 'Follow',
                        onPressed: (){},
                      ),
                    ],
                  ),
                  SliverPadding(
                    padding: EdgeInsets.all(15),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          TabBar(
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Theme.of(context).primaryColor,
                            tabs: [
                            new Tab(text: "Posts (3)"),
                            new Tab(
                            text: "Followers (67)"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ];
              },
                body: Center(
                    child: Text("Sample text"),
            ),
          ),
      ),
    );
  }
}
