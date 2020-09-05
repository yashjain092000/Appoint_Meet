import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detailList.dart';
import 'detailsClass.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  Widget A = StreamBuilder(
      stream: Firestore.instance.collection('users').snapshots(),
      builder: (ctx, streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final document = streamSnapshot.data.documents;

        for (int i = 0; i < document.length; i++) {
          detailList.add(new Details(document[i]['typeUser'],
              document[i]['username'], document[i]['email']));
        }
        deleteDublicate();

        return Text('halwa');
      });
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[Text('afhahhka'), A]);
  }
}
