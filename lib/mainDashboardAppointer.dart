import 'package:Appoint_Meet/picker/prescription.dart';
import 'package:flutter/material.dart';
import 'CarouselPage.dart';
import 'appointmentsClass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'morningEveningTime.dart';
import 'package:toast/toast.dart';

bool stopIsEnabled = false;
String holidayText = "Off";
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
  String _id = "";
  bool _bookStatus = true;
  getCurrentDoctorsMail() async {
    final FirebaseUser user = await auth.currentUser();
    final uemail = user.email;
    setState(() {
      currentDoctorsMail = uemail;
    });
    print(currentDoctorsMail);
  }

  userDocumentIdAppointer() async {
    await Firestore.instance
        .collection("Appointers")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      for (int i = 0; i < snapshot.documents.length; i++) {
        if (snapshot.documents[i]['userEmail'].compareTo(currentDoctorsMail) ==
            0) {
          snapshot.documents[i].documentID;
          setState(() {
            _id = snapshot.documents[i].documentID;
            _bookStatus = snapshot.documents[i]['canBook'];
            holidayText = _bookStatus ? "Off" : "On";
          });
        }
      }
    });
    print(_bookStatus.toString());
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
      n = morningTime.toString() + ":" + (patTime * m).toString() + " am";
    } else if ((patTime * m) >= 60) {
      n = (morningTime + 1).toString() + ":" + (patTime * g).toString() + " am";
    }
    return n;
  }

  String gTimeEvening(int m) {
    String n;
    int g = m % 6;
    if ((patTime * m) < 60) {
      n = eveningTime.toString() + ":" + (patTime * m).toString() + " pm";
    } else if ((patTime * m) >= 60) {
      n = (eveningTime + 1).toString() + ":" + (patTime * g).toString() + " pm";
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
    userDocumentIdAppointer();
    print(_bookStatus);
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Holiday Mode is ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
            Center(
                child: Text(
              "$holidayText",
              style: TextStyle(
                  color: _bookStatus ? Colors.green : Colors.red,
                  fontSize: 22,
                  fontWeight: FontWeight.w900),
            )),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10),
          child: Divider(thickness: 0.3, color: Colors.deepPurple),
        ),
        CarouselPage(),
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
                        padding: const EdgeInsets.only(
                            top: 7.0, left: 7, right: 7, bottom: 3),
                        child: Text(
                          "Your Appointments",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.065,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline),
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
                  height: 2,
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
              disabledColor: Colors.grey,
              onPressed: _bookStatus
                  ? () {
                      print("stop appointments");
                      Firestore.instance
                          .collection("Appointers")
                          .document(_id)
                          .updateData({'canBook': false});

                      Toast.show("Appointment booking stopped!!", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      setState(() {
                        stopIsEnabled = true;
                        _bookStatus = false;
                        holidayText = "On";
                      });
                    }
                  : null,
              color: Colors.deepPurple,
              child: Text(
                "Stop Appointments",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            RaisedButton(
              onPressed: !_bookStatus
                  ? () {
                      print("start appointments");

                      Firestore.instance
                          .collection("Appointers")
                          .document(_id)
                          .updateData({'canBook': true});
                      Toast.show("Appointment booking resumed!", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      setState(() {
                        stopIsEnabled = false;
                        _bookStatus = true;
                        holidayText = "Off";
                      });
                    }
                  : null,
              color: Colors.deepPurple,
              child: Text(
                "Start Appointments",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10),
          child: Divider(thickness: 0.3, color: Colors.deepPurple),
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
                          DateTime.parse(docu[i]['BookingTime']),
                          docu[i]['id'].toString()));
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
                Widget prescription(Appointments a) {
                  String prescrip = " ";
                  for (int i = 0; i < docu.length; i++) {
                    if (a.bookingDate ==
                        DateTime.parse(docu[i]['BookingTime'])) {
                      prescrip = docu[i]['Appointment_prescription'];
                    }
                  }
                  return prescrip.compareTo("not uploaded yet") == 0
                      ? PrescriptionPicker(a.bookingDate.toString(), a.id)
                      : FlatButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (_) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(prescrip),
                                    ),
                                  );
                                });
                          },
                          child: Text("Prescription"));
                }

                return ListView.builder(
                    //shrinkWrap: true,
                    itemCount: docAppointments.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: ListTile(
                              leading: Text(" " + (index + 1).toString() + " ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      backgroundColor: Colors.deepPurple)),
                              title: Text(docAppointments[index].email),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(docAppointments[index].currentUserMail),
                                  Text(time(index + 1, index)),
                                  prescription(docAppointments[index]),
                                ],
                              ),
                              trailing: IconButton(
                                  icon: Icon(Icons.delete,
                                      color: Colors.deepPurple),
                                  onPressed: () {
                                    Firestore.instance
                                        .collection("Appointments")
                                        .document(docAppointments[index].id)
                                        .delete();
                                    Firestore.instance
                                        .collection("Notification")
                                        .document()
                                        .setData({
                                      "message": "Your appointment" +
                                          " @ " +
                                          time(index + 1, index).toString() +
                                          " with " +
                                          currentDoctorsMail +
                                          " is cancelled",
                                      "mail": docAppointments[index].email,
                                      "date": DateTime.now().toString(),
                                    });
                                    docAppointments.removeAt(index);

                                    Toast.show("Appointment Deleted!!", context,
                                        duration: Toast.LENGTH_SHORT,
                                        gravity: Toast.BOTTOM);
                                  })));
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
