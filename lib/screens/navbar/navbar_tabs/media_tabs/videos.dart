import 'package:better_player/better_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../components.dart';

class Videos extends StatefulWidget {
  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("videos")
            .orderBy("createdAt")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Components().circularProgressIndicator();
          if (snapshot.hasError) return Center(child: Icon(Icons.error));
          if (snapshot.hasData) {
            var documents = [];
            for (var snap in snapshot.data.docs.reversed)
              documents.add(snap.data());

            if (documents.isEmpty)
              return Center(
                child: Text(
                  "No videos found...",
                  style: TextStyle(fontSize: 18, fontFamily: "Montserrat"),
                ),
              );
            return ListView.separated(
              physics: BouncingScrollPhysics(),
              itemCount: documents.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 30, thickness: 0, color: Colors.transparent),
              itemBuilder: (context, index) {
                return ClipRRect(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: BetterPlayer.network(
                      documents[index]["photoUrl"],
                      betterPlayerConfiguration: BetterPlayerConfiguration(
                        aspectRatio: 16 / 9,
                      ),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(20),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
