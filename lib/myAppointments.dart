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
              List<Appointments> appointmentsList = [];

              for (int i = 0; i < documen.length; i++) {
                if (documen[i]['currentEmail'] == currentMail) {
                  if (DateTime.parse(documen[i]['appointmentDate']).day <
                      DateTime.now().day) {
                    appointmentsList.add(new Appointments(
                        documen[i]['username'],
                        documen[i]['email'],
                        currentMail,
                        DateTime.parse(documen[i]['appointmentDate']),
                        DateTime.parse(documen[i]['BookingTime']),
                        documen[i]['id'].toString(),
                        documen[i]['doctor_image']));
                  }
                }
              }

              //deleteDublicateAppointment(appointmentsList);
              //sortDate();
              sortList(appointmentsList);
              Widget appointmentNoTime(Appointments a) {
                int n;
                String g = '';
                String prescription = " ";
                for (int i = 0; i < documen.length; i++) {
                  if (a.bookingDate ==
                      DateTime.parse(documen[i]['BookingTime'])) {
                    n = documen[i]['Appointment_no'];
                    g = documen[i]['Appointment_time'];
                    prescription = documen[i]['Appointment_prescription'];
                  }
                }
                return Column(
                  children: [
                    Text("Appointment no.:" + n.toString() + " Time:" + g),
                    prescription.compareTo("not uploaded yet") == 0
                        ? Text(prescription)
                        : FlatButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (_) {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(prescription),
                                      ),
                                    );
                                  });
                            },
                            child: Text("Prescription")),
                  ],
                );
              }

              return ListView.builder(
                  itemCount: appointmentsList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(appointmentsList[index].email),
                        subtitle: Column(
                          children: [
                            Text(appointmentsList[index].currentUserMail),
                            appointmentNoTime(appointmentsList[index]),
                          ],
                        ),
                      ),
                    );
                  });
            }));
  }
}
