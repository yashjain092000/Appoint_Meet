import 'package:flutter/material.dart';
import 'CarouselPage.dart';
import 'appointmentsClass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'morningEveningTime.dart';

String currentDoctorsMail;
int morningTime = 0;
int eveningTime = 0;
double totalAppointmentsMorning = 0;
double totalAppointmentsEvening = 0;

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
  }

  Widget getCurrentDoctor = StreamBuilder(
      stream: Firestore.instance.collection('Appointers').snapshots(),
      builder: (ctx, streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final document = streamSnapshot.data.documents;

        for (int i = 0; i < document.length; i++) {
          doctorsTimeTable.add(new TimeTable(
              document[i]['userEmail'],
              DateTime.parse(document[i]['morning_start_time']),
              DateTime.parse(document[i]['morning_end_time']),
              DateTime.parse(document[i]['evening_start_time']),
              DateTime.parse(document[i]['evening_end_time']),
              document[i]['patient_time']));
        }
        deleteDuplicateDoctor();
        return SizedBox();
      });

  Widget getTime() {
    for (int i = 0; i < doctorsTimeTable.length; i++) {
      if (currentDoctorsMail.compareTo(doctorsTimeTable[i].doctorsMail) == 0) {
        //print(doctorsTimeTable[i].morningEndTime.hour);
        setState(() {
          morningTime = doctorsTimeTable[i].morningEndTime.hour -
              doctorsTimeTable[i].morningStartTime.hour;
          eveningTime = doctorsTimeTable[i].eveningEndTime.hour -
              doctorsTimeTable[i].eveningStartTime.hour;
        });
      }
    }
    return SizedBox(height: 5);
  }

  Widget getTotalAppointments() {
    for (int i = 0; i < doctorsTimeTable.length; i++) {
      if (currentDoctorsMail.compareTo(doctorsTimeTable[i].doctorsMail) == 0) {
        //print(doctorsTimeTable[i].morningEndTime.hour);
        setState(() {
          totalAppointmentsMorning =
              (morningTime) * 60 / doctorsTimeTable[i].pTime;
          totalAppointmentsEvening =
              (eveningTime) * 60 / doctorsTimeTable[i].pTime;
        });
      }
    }
    return SizedBox(height: 5);
  }

  String gTimeMorning(int m) {
    String n;
    int g = m % 6;
    for (int i = 0; i < doctorsTimeTable.length; i++) {
      if (currentDoctorsMail.compareTo(doctorsTimeTable[i].doctorsMail) == 0) {
        if ((doctorsTimeTable[i].pTime * m) < 60) {
          n = doctorsTimeTable[i].morningStartTime.hour.toString() +
              ":" +
              (doctorsTimeTable[i].pTime * m).toString();
        } else if ((doctorsTimeTable[i].pTime * m) >= 60) {
          n = (doctorsTimeTable[i].morningStartTime.hour + 1).toString() +
              ":" +
              (doctorsTimeTable[i].pTime * g).toString();
        }
      }
    }
    return n;
  }

  String gTimeEvening(int m) {
    String n;
    int g = m % 6;
    for (int i = 0; i < doctorsTimeTable.length; i++) {
      if (currentDoctorsMail.compareTo(doctorsTimeTable[i].doctorsMail) == 0) {
        if ((doctorsTimeTable[i].pTime * m) < 60) {
          n = doctorsTimeTable[i].eveningStartTime.hour.toString() +
              ":" +
              (doctorsTimeTable[i].pTime * m).toString();
        } else if ((doctorsTimeTable[i].pTime * m) >= 60) {
          n = (doctorsTimeTable[i].eveningStartTime.hour + 1).toString() +
              ":" +
              (doctorsTimeTable[i].pTime * g).toString();
        }
      }
    }
    return n;
  }

  String time(int c, int d) {
    if (c > totalAppointmentsMorning) {
      return gTimeEvening(d);
    }
    return gTimeMorning(d);
  }

  void initState() {
    super.initState();
    getCurrentDoctorsMail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(
          height: 30,
        ),
        CarouselPage(),
        getCurrentDoctor,
        getTime(),
        getTotalAppointments(),
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
                            child: Text(
                                (totalAppointmentsMorning +
                                        totalAppointmentsEvening)
                                    .truncate()
                                    .toString(),
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
                      doctorsAppointments.add(new Appointments(
                          docu[i]['username'],
                          docu[i]['currentEmail'],
                          currentDoctorsMail,
                          DateTime.parse(docu[i]['appointmentDate']),
                          DateTime.parse(docu[i]['BookingTime'])));
                    }
                  }
                }
                deleteDublicateTodaysAppointment(doctorsAppointments);
                sortList(doctorsAppointments);
                for (int i = 0; i < doctorsAppointments.length; i++) {
                  for (int j = 0; j < docu.length; j++) {
                    if (doctorsAppointments[i].bookingDate ==
                        DateTime.parse(docu[j]['BookingTime'])) {
                      Firestore.instance
                          .collection("Appointments")
                          .document((j + 1).toString())
                          .updateData({
                        "Appointment_no": (i + 1),
                        "Appointment_time": time(i + 1, i)
                      });
                    }
                  }
                }
                //print(todaysAppointments);
                return ListView.builder(
                    //shrinkWrap: true,
                    itemCount: doctorsAppointments.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(doctorsAppointments[index].email),
                          subtitle:
                              Text(doctorsAppointments[index].currentUserMail),
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
