import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: Firestore.instance.collection('Notification').snapshots(),
            builder: (ctx, streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final documen = streamSnapshot.data.documents;
              List<String> cd = [];
              for (int i = 0; i < documen.length; i++) {
                if (documen[i]['mail'] == _currentMail &&
                    (DateTime.now().day + DateTime.now().month) ==
                        (DateTime.parse(documen[i]['date']).day +
                            DateTime.parse(documen[i]['date']).month)) {
                  cd.add(documen[i]['message']);
                }
              }
              //deleteDublicateAppointment(previousAppointments);
              //sortDate();
              //sortList(previousAppointments);
              return ListView.builder(
                  itemCount: cd.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(cd[index]),
                      ),
                    );
                  });
            }));
  }
}
