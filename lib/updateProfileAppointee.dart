import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'picker/user_image_picker.dart';

class UpdateProfileScreenAppointee extends StatefulWidget {
  @override
  _UpdateProfileScreenAppointeeState createState() =>
      _UpdateProfileScreenAppointeeState();
}

class _UpdateProfileScreenAppointeeState
    extends State<UpdateProfileScreenAppointee> {
  String currentUserEmail = "";
  String _userName = "";
  String _id = "";
  String _phn = "";
  String _address = "";
  String _newPassword = "";
  //String _url = "";
  String _userType = "";

  void _changePassword(String password, BuildContext context) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (password.length < 7) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "password length should at least be 7",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepPurple,
        ),
      );
    } else {
      user.updatePassword(password);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "password updated",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepPurple,
        ),
      );
    }
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentUserMail() async {
    final FirebaseUser user = await auth.currentUser();
    final uemail = user.email;
    setState(() {
      currentUserEmail = uemail;
    });
    print(currentUserEmail);
  }

  userDocumentIdAppointee() async {
    await Firestore.instance
        .collection("users")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      for (int i = 0; i < snapshot.documents.length; i++) {
        if (snapshot.documents[i]['email'].compareTo(currentUserEmail) == 0) {
          snapshot.documents[i].documentID;
          setState(() {
            _id = snapshot.documents[i].documentID;
          });
        }
      }
    });
  }

  /*userImageUrl() async {
    await Firestore.instance
        .collection("users")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      for (int i = 0; i < snapshot.documents.length; i++) {
        if (snapshot.documents[i]['email'].compareTo(currentUserEmail) == 0) {
          setState(() {
            _url = snapshot.documents[i]['profile_image'];
            _userType = snapshot.documents[i]['typeUser'];
          });
        }
      }
    });
  }*/

  void initState() {
    super.initState();
    getCurrentUserMail();
    userDocumentIdAppointee();
    //userImageUrl();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 50),
          SizedBox(
            width: 250.0,
            child: TypewriterAnimatedTextKit(
                onTap: () {
                  print("Tap Event");
                },
                speed: Duration(milliseconds: 300),
                repeatForever: true,
                text: ["Update Your Details"],
                textStyle: TextStyle(
                    fontSize: 26.5,
                    fontFamily: "Agne",
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.start,
                alignment: AlignmentDirectional.topStart),
          ),
          Text(_userType),
          SizedBox(height: 20.0),
          Container(
            padding: EdgeInsets.all(10.0),
            child: UserImagePicker(currentUserEmail, _id),
          ),
          Center(
            child: Expanded(
              child: Card(
                shadowColor: Colors.deepPurple,
                elevation: 20.0,
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    // key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              _userName = value;
                            });
                          },
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.deepPurple),
                              ),
                              labelText: "username",
                              labelStyle: TextStyle(color: Colors.grey[600])),
                        ),
                        RaisedButton(
                          elevation: 6.0,
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                          child: Text('UpDate UserName'),
                          onPressed: () {
                            Firestore.instance
                                .collection("Appointees")
                                .document(_id)
                                .updateData({"username": _userName});
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "username updated",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.deepPurple,
                              ),
                            );
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.deepPurple),
                              ),
                              labelText: 'Phone No.',
                              labelStyle: TextStyle(color: Colors.grey[600])),
                          onChanged: (value) {
                            setState(() {
                              _phn = value;
                            });
                          },
                        ),
                        RaisedButton(
                          elevation: 6.0,
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                          child: Text('UpDate Phone No.'),
                          onPressed: () {
                            Firestore.instance
                                .collection("Appointees")
                                .document(_id)
                                .updateData({"phone no.": _phn});
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "phone no. updated",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.deepPurple,
                              ),
                            );
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.deepPurple),
                              ),
                              labelText: 'Address',
                              labelStyle: TextStyle(color: Colors.grey[600])),
                          onChanged: (value) {
                            setState(() {
                              _address = value;
                            });
                          },
                        ),
                        RaisedButton(
                          elevation: 6.0,
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                          child: Text('UpDate Address'),
                          onPressed: () {
                            Firestore.instance
                                .collection("Appointees")
                                .document(_id)
                                .updateData({"address": _address});
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "address updated",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.deepPurple,
                              ),
                            );
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.deepPurple),
                              ),
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.grey[500])),
                          obscureText: true,
                          onChanged: (value) {
                            setState(() {
                              _newPassword = value;
                            });
                          },
                        ),
                        SizedBox(height: 12),
                        RaisedButton(
                          elevation: 6.0,
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                          child: Text('update password'),
                          onPressed: () {
                            _changePassword(_newPassword, context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
