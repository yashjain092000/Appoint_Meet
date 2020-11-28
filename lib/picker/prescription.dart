import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';

class PrescriptionPicker extends StatefulWidget {
  PrescriptionPicker(this.date, this.id);
  final String id;
  final String date;
  @override
  _PrescriptionPickerState createState() => _PrescriptionPickerState();
}

class _PrescriptionPickerState extends State<PrescriptionPicker> {
  String _currentUserEmail = "";
  File _pickedImage;
  final picker = ImagePicker();
  void _pickImage() async {
    final pickedImageFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _pickedImage = File(pickedImageFile.path);
    });
    //print(widget.date);
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
        .child("appointment_prescription")
        .child(widget.date + '.jpg');

    await ref.putFile(_pickedImage).onComplete;
    final profileImageUrl = await ref.getDownloadURL();
    Firestore.instance
        .collection("Appointments")
        .document(widget.id)
        .updateData({"Appointment_prescription": profileImageUrl});

    Toast.show("Prescription uploaded!!", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentUserMail() async {
    final FirebaseUser user = await auth.currentUser();
    final uemail = user.email;
    setState(() {
      _currentUserEmail = uemail;
    });
    print(_currentUserEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.deepPurple,
          backgroundImage: _pickedImage != null
              ? FileImage(_pickedImage)
              : AssetImage('images/qimg.png'),
        ),
        FlatButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.camera),
            label: Text("Add by camera")),
        FlatButton.icon(
            onPressed: _pickImageThroughGallery,
            icon: Icon(Icons.image),
            label: Text("Add by gallery")),
        RaisedButton(
            color: Colors.deepPurple,
            elevation: 4,
            onPressed: _uploadImage,
            child: Text(
              "Upload Prescription",
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
  }
}
