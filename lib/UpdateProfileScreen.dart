//import 'package:Appoint_Meet/picker/prescription.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'picker/user_image_picker.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  String currentUserEmail = "";
  String _userName = "";
  String _id = "";
  String _phn = "";
  String _specialisation = "";
  String _address = "";
  int _normFee = 0;
  int _emFee = 0;
  int _ptime = 0;
  String _morTime1;
  String _morTime2;
  String _eveTime1;
  String _eveTime2;
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

  userDocumentIdAppointer() async {
    await Firestore.instance
        .collection("Appointers")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      for (int i = 0; i < snapshot.documents.length; i++) {
        if (snapshot.documents[i]['userEmail'].compareTo(currentUserEmail) ==
            0) {
          snapshot.documents[i].documentID;
          setState(() {
            _id = snapshot.documents[i].documentID;
          });
        }
      }
    });
  }

  /* userImageUrl() async {
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
    userDocumentIdAppointer();
    //userImageUrl();
    //print(_userType);
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
            child: UserImagePicker(currentUserEmail, _id, "Appointer"),
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
                                .collection("Appointers")
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
                                .collection("Appointers")
                                .document(_id)
                                .updateData({"phone_no": _phn});
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
                              labelText: 'Your Specialisation',
                              labelStyle: TextStyle(color: Colors.grey[600])),
                          onChanged: (value) {
                            setState(() {
                              _specialisation = value;
                            });
                          },
                        ),
                        RaisedButton(
                          elevation: 6.0,
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                          child: Text('UpDate Specialisation'),
                          onPressed: () {
                            Firestore.instance
                                .collection("Appointers")
                                .document(_id)
                                .updateData(
                                    {"specialisation": _specialisation});
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "specialisation updated",
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
                                .collection("Appointers")
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
                              labelText: 'Normal Fee',
                              labelStyle: TextStyle(color: Colors.grey[600])),
                          onChanged: (value) {
                            setState(() {
                              _normFee = int.parse(value);
                            });
                          },
                        ),
                        RaisedButton(
                          elevation: 6.0,
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                          child: Text('UpDate Fee(normal)'),
                          onPressed: () {
                            Firestore.instance
                                .collection("Appointers")
                                .document(_id)
                                .updateData({"normal_fee": _normFee});
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "normal fee updated",
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
                              labelText: 'Emergency Fee',
                              labelStyle: TextStyle(color: Colors.grey[600])),
                          onChanged: (value) {
                            setState(() {
                              _emFee = int.parse(value);
                            });
                          },
                        ),
                        RaisedButton(
                          elevation: 6.0,
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                          child: Text('UpDate Emergency fee'),
                          onPressed: () {
                            Firestore.instance
                                .collection("Appointers")
                                .document(_id)
                                .updateData({"emergency_fee": _emFee});
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "emergency fee updated",
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
                              labelText: 'Patient Time',
                              labelStyle: TextStyle(color: Colors.grey[600])),
                          onChanged: (value) {
                            setState(() {
                              _ptime = int.parse(value);
                            });
                          },
                        ),
                        RaisedButton(
                          elevation: 6.0,
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                          child: Text('UpDate Patient Time'),
                          onPressed: () {
                            Firestore.instance
                                .collection("Appointers")
                                .document(_id)
                                .updateData({"patient_time": _ptime});
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Patient time updated",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.deepPurple,
                              ),
                            );
                          },
                        ),
                        Column(children: <Widget>[
                          FlatButton(
                              onPressed: () {
                                DatePicker.showTime12hPicker(context,
                                    showTitleActions: true, onChanged: (date) {
                                  print('change $date in time zone ' +
                                      date.timeZoneOffset.inHours.toString());
                                }, onConfirm: (date) {
                                  _morTime1 = DateFormat("yyyy-MM-dd HH:mm:ss")
                                      .format(date);
                                  // print(_morTime1);
                                }, currentTime: DateTime.now());
                              },
                              child: Text(
                                'Enter Shift-I start time',
                                textAlign: TextAlign.start,
                                style: TextStyle(color: Colors.grey[500]),
                              )),
                          Divider(
                            color: Colors.grey[500],
                            thickness: 1.0,
                          ),
                          RaisedButton(
                            elevation: 6.0,
                            color: Colors.deepPurple,
                            textColor: Colors.white,
                            child: Text('UpDate morning shift start time'),
                            onPressed: () {
                              Firestore.instance
                                  .collection("Appointers")
                                  .document(_id)
                                  .updateData(
                                      {"morning_start_time": _morTime1});
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "morning shift updated",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.deepPurple,
                                ),
                              );
                            },
                          ),
                          FlatButton(
                              onPressed: () {
                                DatePicker.showTime12hPicker(context,
                                    showTitleActions: true, onChanged: (date) {
                                  print('change $date in time zone ' +
                                      date.timeZoneOffset.inHours.toString());
                                }, onConfirm: (date) {
                                  _morTime2 = DateFormat("yyyy-MM-dd HH:mm:ss")
                                      .format(date);
                                  // print(_morTime2);
                                }, currentTime: DateTime.now());
                              },
                              child: Text(
                                'Enter Shift-I end time',
                                textAlign: TextAlign.start,
                                style: TextStyle(color: Colors.grey[500]),
                              )),
                          Divider(
                            color: Colors.grey[500],
                            thickness: 1.0,
                          ),
                          RaisedButton(
                            elevation: 6.0,
                            color: Colors.deepPurple,
                            textColor: Colors.white,
                            child: Text('UpDate morning shift end time'),
                            onPressed: () {
                              Firestore.instance
                                  .collection("Appointers")
                                  .document(_id)
                                  .updateData({"morning_end_time": _morTime2});
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "morning shift updated",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.deepPurple,
                                ),
                              );
                            },
                          ),
                          FlatButton(
                              onPressed: () {
                                DatePicker.showTime12hPicker(context,
                                    showTitleActions: true, onChanged: (date) {
                                  print('change $date in time zone ' +
                                      date.timeZoneOffset.inHours.toString());
                                }, onConfirm: (date) {
                                  _eveTime1 = DateFormat("yyyy-MM-dd HH:mm:ss")
                                      .format(date);
                                  // print(_eveTime1);
                                }, currentTime: DateTime.now());
                              },
                              child: Text(
                                'Enter Shift-II start time',
                                textAlign: TextAlign.start,
                                style: TextStyle(color: Colors.grey[500]),
                              )),
                          Divider(
                            color: Colors.grey[500],
                            thickness: 1.0,
                          ),
                          RaisedButton(
                            elevation: 6.0,
                            color: Colors.deepPurple,
                            textColor: Colors.white,
                            child: Text('UpDate evening shift start time'),
                            onPressed: () {
                              Firestore.instance
                                  .collection("Appointers")
                                  .document(_id)
                                  .updateData(
                                      {"evening_start_time": _eveTime1});
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "evening shift updated",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.deepPurple,
                                ),
                              );
                            },
                          ),
                          FlatButton(
                              onPressed: () {
                                DatePicker.showTime12hPicker(context,
                                    showTitleActions: true, onChanged: (date) {
                                  print('change $date in time zone ' +
                                      date.timeZoneOffset.inHours.toString());
                                }, onConfirm: (date) {
                                  _eveTime2 = DateFormat("yyyy-MM-dd HH:mm:ss")
                                      .format(date);
                                  //print(_eveTime2);
                                }, currentTime: DateTime.now());
                              },
                              child: Text(
                                'Enter Shift-II end time',
                                textAlign: TextAlign.start,
                                style: TextStyle(color: Colors.grey[500]),
                              )),
                          Divider(
                            color: Colors.grey[500],
                            thickness: 1.0,
                          ),
                          RaisedButton(
                            elevation: 6.0,
                            color: Colors.deepPurple,
                            textColor: Colors.white,
                            child: Text('UpDate evening shift end time'),
                            onPressed: () {
                              Firestore.instance
                                  .collection("Appointers")
                                  .document(_id)
                                  .updateData({"evening_end_time": _eveTime2});
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "morning shift updated",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.deepPurple,
                                ),
                              );
                            },
                          ),
                        ]),
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
