import 'package:Appoint_Meet/appointmentsClass.dart';
//import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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
    //final uid = user.uid;
    final uemail = user.email;
    setState(() {
      currentMail = uemail;
    });
    //print(uemail);
  }

  void initState() {
    super.initState();
    getCurrentUserMail();
  }

  /* Widget getAppointmentsList() {
    return StreamBuilder(
        stream: Firestore.instance.collection('Appointments').snapshots(),
        builder: (ctx, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final documen = streamSnapshot.data.documents;

          for (int i = 0; i < documen.length; i++) {
            appointmentsList.add(
                new Appointments(documen[i]['email'], documen[i]['username']));
          }
          deleteDublicateAppointment();

          return SizedBox(height: 10);
        });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            /*Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          getAppointmentsList(),
          appointmentsList.isEmpty
              ? Text("no Appointments")
              : Expanded(
                  child: ListView.builder(
                      itemCount: appointmentsList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 10.0,
                          shadowColor: Colors.deepPurple[400],
                          color: Colors.white,
                          child: ListTile(
                              title: Center(
                                  child:
                                      Text(appointmentsList[index].userName)),
                              subtitle: Center(
                                  child: Text(appointmentsList[index].email))),
                        );
                      }))
        ],
      ),*/
            StreamBuilder(
                stream:
                    Firestore.instance.collection('Appointments').snapshots(),
                builder: (ctx, streamSnapshot) {
                  if (streamSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final documen = streamSnapshot.data.documents;
                  for (int i = 0; i < documen.length; i++) {
                    appointmentsList.add(new Appointments(
                        documen[i]['username'],
                        documen[i]['email'],
                        currentMail));
                  }
                  deleteDublicateAppointment();

                  return ListView.builder(
                      itemCount: appointmentsList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(appointmentsList[index].email),
                          subtitle:
                              Text(appointmentsList[index].currentUserMail),
                        );
                      });
                }));
  }
}
