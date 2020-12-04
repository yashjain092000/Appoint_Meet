import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';

class UserImagePicker extends StatefulWidget {
  final String email;
  final String id;
  final String typeUser;
  UserImagePicker(this.email, this.id, this.typeUser);
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  final picker = ImagePicker();
  void _pickImage() async {
    final pickedImageFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _pickedImage = File(pickedImageFile.path);
    });
  }

  void _pickImageThroughGallery() async {
    final pickedImageFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = File(pickedImageFile.path);
    });
  }

  void _uploadImage() async {
    final ref = FirebaseStorage.instance
        .ref()
        .child("user_images")
        .child(widget.email + '.jpg');

    await ref.putFile(_pickedImage).onComplete;
    final profileImageUrl = await ref.getDownloadURL();
    if (widget.typeUser.compareTo("Appointer") == 0) {
      Toast.show("Please wait...", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Firestore.instance
          .collection("Appointers")
          .document(widget.id)
          .updateData({"profile_image": profileImageUrl});
      Toast.show("Profile photo updated!!", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      Toast.show("Please wait...", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Firestore.instance
          .collection("users")
          .document(widget.id)
          .updateData({"profile_image": profileImageUrl});
      Toast.show("Profile photo updated!!", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.deepPurple,
          radius: 100,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        FlatButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.image),
            label: Text("Add Image by camera")),
        FlatButton.icon(
            onPressed: _pickImageThroughGallery,
            icon: Icon(Icons.image),
            label: Text("Add Image by gallery")),
        FlatButton(onPressed: _uploadImage, child: Text("Upload Profile photo"))
      ],
    );
  }
}
