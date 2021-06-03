import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../components.dart';

class Photos extends StatefulWidget {
  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("photos").orderBy("createdAt").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Components().circularProgressIndicator();
          if (snapshot.hasError) return Center(child: Icon(Icons.error));
          if (snapshot.hasData) {
            var documents = [];
            for (var snap in snapshot.data.docs.reversed) documents.add(snap.data());

            if (documents.isEmpty)
              return Center(
                child: Text(
                  "No photos found...",
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
                  child: CachedNetworkImage(
                    imageUrl: documents[index]["photoUrl"],
                    placeholder: (context, url) =>
                        Components().circularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.4,
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
