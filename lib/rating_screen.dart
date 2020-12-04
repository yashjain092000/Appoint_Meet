import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

String currentUserMail;
AuthResult authResult;
FirebaseUser user;

class RatingScreen extends StatefulWidget {
  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentUserMail() async {
    user = await auth.currentUser();
    final uemail = user.email;
    setState(() {
      currentUserMail = uemail;
    });
    print(currentUserMail.toString());
  }

  var rating = 3.0;
  String feedback = "";

  void initState() {
    super.initState();
    getCurrentUserMail();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Center(
              child: Text(
                "Please Rate Us!!",
                style: TextStyle(fontSize: 32),
              ),
            ),
            Center(
              child: SmoothStarRating(
                color: Colors.yellow,
                borderColor: Colors.deepPurple,
                rating: rating,
                isReadOnly: false,
                size: 50,
                filledIconData: Icons.star,
                halfFilledIconData: Icons.star_half,
                defaultIconData: Icons.star_border,
                starCount: 5,
                allowHalfRating: true,
                spacing: 2.0,
                onRated: (value) {
                  setState(() {
                    rating = value;
                  });
                  print("rating value -> $value");

                  // print("rating value dd -> ${value.truncate()}");
                },
              ),
            ),
          ],
        ),
        Column(children: [
          Padding(
            padding: EdgeInsets.only(left: 18.0, right: 18),
            child: TextField(
                decoration: InputDecoration(
                  fillColor: Colors.deepPurple,
                  focusColor: Colors.deepPurple,
                  hintText: "Your Feedback here...",
                  hintStyle: TextStyle(
                    color: Colors.deepPurple,
                  ),
                ),
                cursorColor: Colors.deepPurple,
                onChanged: (text) {
                  feedback = text;
                  setState(() {
                    feedback = text;
                  });
                }),
          ),
          SizedBox(height: 40),
          RaisedButton(
            elevation: 4,
            color: Colors.deepPurple,
            child: Text("Submit",
                style: TextStyle(color: Colors.white, fontSize: 20)),
            onPressed: () {
              Firestore.instance.collection('feedback').document().setData({
                'email': currentUserMail,
                'feedback': feedback,
                'rating': rating,
              });

              Toast.show("Thanks for your Feedback!!", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            },
          )
        ])
      ],
    );
  }
}
