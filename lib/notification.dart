import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

List<String> noti = [];
int oldCount = 0;
int newCount = 0;

class Count {
  int getCount() {
    return newCount - oldCount;
  }

  void zeroCount() {
    newCount = 0;
  }
}

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _currentMail = "";
  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentUserMail() async {
    final FirebaseUser user = await auth.currentUser();
    final uemail = user.email;
    setState(() {
      _currentMail = uemail;
    });
  }

  void initState() {
    super.initState();
    getCurrentUserMail();
    oldCount = newCount;
    newCount = noti.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Notifications"),
          backgroundColor: Colors.deepPurple,
          shadowColor: Colors.deepPurple,
          elevation: 9.0,
        ),
        body: StreamBuilder(
            stream: Firestore.instance.collection('Notification').snapshots(),
            builder: (ctx, streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final documen = streamSnapshot.data.documents;

              for (int i = 0; i < documen.length; i++) {
                if (documen[i]['mail'] == _currentMail) {
                  noti.add(documen[i]['message']);
                }
              }
              if (noti.length == 0)
                return Center(
                    child: Text(
                  "No Notifications!!",
                  style: TextStyle(fontSize: 20),
                ));
              return ListView.builder(
                  itemCount: noti.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(noti[index]),
                      ),
                    );
                  });
            }));
  }
}
