import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _textStyle = TextStyle(
      fontFamily: "Montserrat",
      letterSpacing: 2,
      color: Color(0xff1b4d3e),
      fontWeight: FontWeight.bold,
      fontSize: 22);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              "Users",
              style: _textStyle.copyWith(fontSize: 16, fontFamily: "CarterOne"),
            ),
          ),
          SizedBox(width: 10)
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Components().circularProgressIndicator();
            if (snapshot.hasError) return Center(child: Icon(Icons.error));

            if (snapshot.hasData) {
              var documents = [];
              for (var snap in snapshot.data.docs) documents.add(snap.data());

              return ListView.separated(
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xff00a86b).withOpacity(0.4)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                  documents[index]["photoUrl"],
                                ),
                              ),
                              SizedBox(width: 20),
                              Text(
                                documents[index]["name"],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Montserrat",
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            documents[index]["email"],
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: documents.length,
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
