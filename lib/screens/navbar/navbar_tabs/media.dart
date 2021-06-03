import 'package:anihelp_admin/screens/navbar/navbar_tabs/media_tabs/photos.dart';
import 'package:anihelp_admin/screens/navbar/navbar_tabs/media_tabs/upload_media.dart';
import 'package:anihelp_admin/screens/navbar/navbar_tabs/media_tabs/videos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MediaScreen extends StatefulWidget {
  @override
  _MediaScreenState createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  final _textStyle = TextStyle(
      fontFamily: "Montserrat",
      letterSpacing: 2,
      color: Color(0xff1b4d3e),
      fontWeight: FontWeight.bold,
      fontSize: 22);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Color(0xff00a86b),
          leading: IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              return Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
            color: Color(0xff1b4d3e),
            iconSize: 16,
          ),
          actions: [
            Center(
              child: Text(
                "Media",
                style:
                    _textStyle.copyWith(fontSize: 16, fontFamily: "CarterOne"),
              ),
            ),
            SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: Colors.transparent.withOpacity(0.2),
              child: IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => UploadMediaScreen(),
                  ),
                ),
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10)
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: TextStyle(
                fontFamily: "CarterOne",
                fontWeight: FontWeight.bold,
                letterSpacing: 3),
            tabs: [
              Tab(text: "Photos"),
              Tab(text: "Videos"),
            ],
            enableFeedback: true,
          ),
        ),
        body: TabBarView(
          children: [
            Photos(),
            Videos(),
          ],
        ),
      ),
    );
  }
}
