import 'package:Appoint_Meet/appointmentsClass.dart';
//import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentsScreen extends StatefulWidget {
  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
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
                appointmentsList.add(new Appointments(
                    documen[i]['email'], documen[i]['username']));
              }
              deleteDublicateAppointment();

              return ListView.builder(
                  itemCount: appointmentsList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(appointmentsList[index].email),
                    );
                  });
            }));
  }
}
