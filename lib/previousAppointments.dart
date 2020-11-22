import 'package:Appoint_Meet/appointmentsClass.dart';
//import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PreviousAppointmentsScreen extends StatefulWidget {
  @override
  _PreviousAppointmentsScreenState createState() =>
      _PreviousAppointmentsScreenState();
}

class _PreviousAppointmentsScreenState
    extends State<PreviousAppointmentsScreen> {
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
              List<Appointments> previousAppointments = [];
              for (int i = 0; i < documen.length; i++) {
                if (documen[i]['email'] == currentMail) {
                  if (DateTime.parse(documen[i]['appointmentDate']).day <
                      DateTime.now().day) {
                    previousAppointments.add(new Appointments(
                        documen[i]['username'],
                        documen[i]['email'],
                        documen[i]['currentEmail'],
                        DateTime.parse(documen[i]['appointmentDate']),
                        DateTime.parse(documen[i]['BookingTime']),
                        documen[i]['id'].toString()));
                  }
                }
              }
              //deleteDublicateAppointment(previousAppointments);
              //sortDate();
              sortList(previousAppointments);
              return ListView.builder(
                  itemCount: previousAppointments.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title:
                            Text(previousAppointments[index].currentUserMail),
                        subtitle: Text(previousAppointments[index].email),
                        trailing: Text((index + 1).toString()),
                      ),
                    );
                  });
            }));
  }
}
