import 'dart:io';
import 'package:better_player/better_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class UploadMediaScreen extends StatefulWidget {
  @override
  _UploadMediaScreenState createState() => _UploadMediaScreenState();
}

class _UploadMediaScreenState extends State<UploadMediaScreen> {
  final _textStyle = TextStyle(
      fontFamily: "Montserrat",
      letterSpacing: 2,
      color: Color(0xff1b4d3e),
      fontWeight: FontWeight.bold,
      fontSize: 22);
  File image;
  File video;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff00a86b),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
          color: Color(0xff1b4d3e),
          iconSize: 16,
        ),
        actions: [
          Center(
            child: Text(
              "Upload",
              style: _textStyle.copyWith(fontSize: 16, fontFamily: "CarterOne"),
            ),
          ),
          SizedBox(width: 10)
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(0.4),
                      ),
                      child: image == null
                          ? Center(
                              child: IconButton(
                                icon: Icon(Icons.add_photo_alternate),
                                iconSize: 30,
                                onPressed: () => pickImageFromGallery(),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(image, fit: BoxFit.fill),
                            ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Flexible(
                    child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withOpacity(0.4),
                        ),
                        child: video == null
                            ? Center(
                                child: IconButton(
                                  icon: Icon(Icons.video_collection),
                                  iconSize: 30,
                                  onPressed: () => pickedVideoFromGallery(),
                                ),
                              )
                            : BetterPlayer.file(video.path)),
                  ),
                ],
              ),
              Flexible(child: SizedBox(height: 100)),
              ElevatedButton(
                onPressed: () {
                  if (video == null && image == null)
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("No image or video selected")));
                  else {
                    if (image != null) uploadImage(context);
                    if (video != null) uploadVideo(context);
                    Navigator.pop(context);
                  }
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 15, horizontal: 70)),
                  backgroundColor: MaterialStateProperty.all(Color(0xff00a86b)),
                ),
                child: Text(
                  "Upload",
                  style: TextStyle(
                      fontFamily: "Montserrat", fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  pickImageFromGallery() async {
    PickedFile pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      image = File(pickedImage.path);
    });
  }

  pickedVideoFromGallery() async {
    PickedFile pickedVideo =
        await ImagePicker().getVideo(source: ImageSource.gallery);
    setState(() {
      image = File(pickedVideo.path);
    });
  }

  uploadImage(BuildContext context) async {
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No image was selected'),
      ));
      return null;
    }

    setState(() => isLoading = true);
    firebase_storage.UploadTask uploadTask;
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(image.path);

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': image.path});
    uploadTask = ref.putFile(File(image.path), metadata);
    Future.value(uploadTask).then((value) async {
      final link = await ref.getDownloadURL();
      FirebaseFirestore.instance.collection("photos").add({
        "photoUrl": link,
        "createdAt": FieldValue.serverTimestamp(),
      });
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Image uploaded successfully'),
      ));
    });
  }

  uploadVideo(BuildContext context) async {
    if (video == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No videos was selected'),
      ));
      return null;
    }

    setState(() => isLoading = true);
    firebase_storage.UploadTask uploadTask;
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(video.path);

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'video/mp4',
        customMetadata: {'picked-file-path': video.path});
    uploadTask = ref.putFile(File(video.path), metadata);
    Future.value(uploadTask).then((value) async {
      final link = await ref.getDownloadURL();
      FirebaseFirestore.instance.collection("videos").add({
        "photoUrl": link,
        "createdAt": FieldValue.serverTimestamp(),
      });
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Video uploaded successfully'),
      ));
    });
  }
}
