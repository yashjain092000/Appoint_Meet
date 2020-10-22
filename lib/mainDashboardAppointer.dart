//import 'package:Appoint_Meet/SearchAppointer.dart';
import 'package:flutter/material.dart';
import 'CarouselPage.dart';
import 'appointmentsClass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'morningEveningTime.dart';
//import 'timeTable.dart';

String currentDoctorsMail;
int morningTime = 0;
int eveningTime = 0;
double totalAppointmentsMorning = 0;
double totalAppointmentsEvening = 0;
int patTime = 0;

class MainDashboardAppointer extends StatefulWidget {
  @override
  _MainDashboardAppointerState createState() => _MainDashboardAppointerState();
}

class _MainDashboardAppointerState extends State<MainDashboardAppointer> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentDoctorsMail() async {
    final FirebaseUser user = await auth.currentUser();
    final uemail = user.email;
    setState(() {
      currentDoctorsMail = uemail;
    });
    print(currentDoctorsMail);
  }

  List<TimeTable> doctorsTimeTable = [];
  timeTable() async {
    await Firestore.instance
        .collection("Appointers")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      for (int i = 0; i < snapshot.documents.length; i++) {
        //print(snapshot.documents[i]['userEmail']);
        doctorsTimeTable.add(TimeTable(
            snapshot.documents[i]['userEmail'],
            DateTime.parse(snapshot.documents[i]['morning_start_time']),
            DateTime.parse(snapshot.documents[i]['morning_end_time']),
            DateTime.parse(snapshot.documents[i]['evening_start_time']),
            DateTime.parse(snapshot.documents[i]['evening_end_time']),
            snapshot.documents[i]['patient_time']));
      }
    });
    deleteDuplicateDoctor(doctorsTimeTable);
    for (int i = 0; i < doctorsTimeTable.length; i++) {
      if (currentDoctorsMail.compareTo(doctorsTimeTable[i].doctorsMail) == 0) {
        //print(doctorsTimeTable[i].morningEndTime.hour);
        setState(() {
          totalAppointmentsMorning = ((doctorsTimeTable[i].morningEndTime.hour -
                      doctorsTimeTable[i].morningStartTime.hour) *
                  60) /
              doctorsTimeTable[i].pTime;
          totalAppointmentsEvening = ((doctorsTimeTable[i].eveningEndTime.hour -
                      doctorsTimeTable[i].eveningStartTime.hour) *
                  60) /
              doctorsTimeTable[i].pTime;
          morningTime = doctorsTimeTable[i].morningStartTime.hour;
          eveningTime = doctorsTimeTable[i].eveningStartTime.hour;
          patTime = doctorsTimeTable[i].pTime;
        });
        //print(totalAppointmentsEvening);
      }
    }
  }

  String gTimeMorning(int m) {
    String n;
    int g = m % 6;

    if ((patTime * m) < 60) {
      n = morningTime.toString() + ":" + (patTime * m).toString();
    } else if ((patTime * m) >= 60) {
      n = (morningTime + 1).toString() + ":" + (patTime * g).toString();
    }
    return n;
  }

  String gTimeEvening(int m) {
    String n;
    int g = m % 6;
    if ((patTime * m) < 60) {
      n = eveningTime.toString() + ":" + (patTime * m).toString();
    } else if ((patTime * m) >= 60) {
      n = (eveningTime + 1).toString() + ":" + (patTime * g).toString();
    }
    return n;
  }

  String time(int c, int d) {
    if (c > totalAppointmentsMorning) {
      return gTimeEvening(d);
    }
    return gTimeMorning(d);
  }

  List<Appointments> docAppointments = [];
  void initState() {
    super.initState();
    getCurrentDoctorsMail();
    timeTable();
    //getTime();
  }

  @override
  Widget build(BuildContext context) {
    //timeTable();
    //deleteDuplicateDoctor(doctorsTimeTable);
    //getTotalAppointments();
    return Scaffold(
      body: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(
          height: 10,
        ),
        CarouselPage(),
        //getTime(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Card(
                  color: Colors.white,
                  shadowColor: Colors.deepPurple[400],
                  elevation: 10.0,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          "Upcoming Appointment at",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: Card(
                          color: Colors.deepPurple,
                          shadowColor: Colors.deepPurple[400],
                          elevation: 10.0,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("2:33 pm",
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
            Column(
              children: [
                Card(
                  color: Colors.white,
                  shadowColor: Colors.deepPurple[400],
                  elevation: 10.0,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "Total Appointments",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: Card(
                          color: Colors.deepPurple,
                          shadowColor: Colors.deepPurple[400],
                          elevation: 10.0,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(docAppointments.length.toString(),
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: StreamBuilder(
              stream: Firestore.instance.collection('Appointments').snapshots(),
              builder: (ctx, streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final docu = streamSnapshot.data.documents;
                for (int i = 0; i < docu.length; i++) {
                  if (docu[i]['email'] == currentDoctorsMail) {
                    if (DateTime.parse(docu[i]['appointmentDate']).day ==
                        (DateTime.now().day)) {
                      docAppointments.add(new Appointments(
                          docu[i]['username'],
                          docu[i]['currentEmail'],
                          currentDoctorsMail,
                          DateTime.parse(docu[i]['appointmentDate']),
                          DateTime.parse(docu[i]['BookingTime'])));
                    }
                  }
                }
                deleteDublicateAppointment(docAppointments);
                sortList(docAppointments);
                //docu.orderBy()
                for (int i = 0; i < docAppointments.length; i++) {
                  for (int j = 0; j < docu.length; j++) {
                    if (docAppointments[i].bookingDate ==
                        DateTime.parse(docu[j]['BookingTime'])) {
                      Firestore.instance
                          .collection("Appointments")
                          .document((docu[j]['id'].toString()))
                          .updateData({
                        "Appointment_no": (i + 1),
                        "Appointment_time": time(i + 1, i)
                      });
                    }
                  }
                }
                return ListView.builder(
                    //shrinkWrap: true,
                    itemCount: docAppointments.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(docAppointments[index].email),
                          subtitle:
                              Text(docAppointments[index].currentUserMail),
                          trailing: Column(
                            children: [
                              Text((index + 1).toString()),
                              Text(time(index + 1, index)),
                            ],
                          ),
                        ),
                      );
                    });
              }),
        ),
      ]),
    );
  }
}

class MainDash extends StatefulWidget {
  @override
  _MainDashState createState() => _MainDashState();
}

class _MainDashState extends State<MainDash> {
  @override
  Widget build(BuildContext context) {
    return MainDashboardAppointer();
  }
}
