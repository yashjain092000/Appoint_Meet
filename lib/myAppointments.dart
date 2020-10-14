import 'package:Appoint_Meet/appointmentsClass.dart';
//import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentsScreen extends StatefulWidget {
  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  String currentMail;
  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentUserMail() async {
    final FirebaseUser user = await auth.currentUser();
    final uemail = user.email;
    setState(() {
      currentMail = uemail;
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
            stream: Firestore.instance.collection('Appointments').snapshots(),
            builder: (ctx, streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final documen = streamSnapshot.data.documents;
              for (int i = 0; i < documen.length; i++) {
                if (documen[i]['currentEmail'] == currentMail) {
                  appointmentsList.add(new Appointments(
                      documen[i]['username'],
                      documen[i]['email'],
                      currentMail,
                      DateTime.parse(documen[i]['appointmentDate']),
                      DateTime.parse(documen[i]['BookingTime'])));
                }
              }
              deleteDublicateAppointment();
              sortDate();
              //sortList();
              return ListView.builder(
                  itemCount: appointmentsList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(appointmentsList[index].email),
                      subtitle: Text(appointmentsList[index].currentUserMail),
                      trailing: Text((index + 1).toString()),
                    );
                  });
            }));
  }
}
