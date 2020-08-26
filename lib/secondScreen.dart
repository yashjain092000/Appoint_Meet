import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('second screen'),
        actions: <Widget>[
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                  child: Container(
                      child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text('LogOut!')
                    ],
                  )),
                  value: 'LogOut!'),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'LogOut!') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      /*body: StreamBuilder(
          stream: Firestore.instance.collection('users').snapshots(),
          builder: (ctx, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final document = streamSnapshot.data.documents;
            return ListView.builder(
                itemCount: document.length,
                itemBuilder: (ctx, index) => Container(
                      child: Text(document[index]['username']),
                    ));
          }),*/
    );
  }
}
