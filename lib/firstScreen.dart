//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detailList.dart';
import 'detailsClass.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('first screen'),
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
        body: StreamBuilder(
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

              return ListView.builder(
                  itemCount: detailList.length,
                  itemBuilder: (context, index) {
                    return //_buildListItem(context, document[index], index);
                        ListTile(
                      title: Text(detailList[index].userName),
                      subtitle: Text(detailList[index].userEmail),
                    );
                  });
            }));
  }
}
