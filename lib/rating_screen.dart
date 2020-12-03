import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter/material.dart';

String currentUserMail;

class RatingScreen extends StatefulWidget {
  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentUserMail() async {
    final FirebaseUser user = await auth.currentUser();
    final uemail = user.email;
    setState(() {
      currentUserMail = uemail;
    });
  }

  var rating = 3.0;
  String feedback = "";

  void initState() {
    super.initState();
    getCurrentUserMail();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rating',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Center(
                  child: Text("Rating"),
                ),
                Center(
                    child: SmoothStarRating(
                  color: Colors.yellow,
                  borderColor: Colors.deepPurple,
                  rating: rating,
                  isReadOnly: false,
                  size: 80,
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
                )),
              ],
            ),
            TextField(onChanged: (text) {
              feedback = text;
              setState(() {
                feedback = text;
              });
            }),
            RaisedButton(
              color: Colors.deepPurple,
              child: Text("Submit",
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onPressed: () async {
                AuthResult authResult;

                await Firestore.instance
                    .collection('feedback')
                    .document(authResult.user.uid)
                    .setData({
                  'email': currentUserMail,
                  'feedback': feedback,
                  'rating': rating,
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
