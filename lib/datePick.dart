import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

DateTime selectedDate = DateTime.now();
DateTime checkDate = DateTime.now();
String appointerMail = '';
String appointeeMail = '';
String userName = '';
String imageUrl = '';
DateTime bookingTime;
int i;
String address = '';
String morTime = '';
String eveTime = '';
String specialisation = '';

// ignore: must_be_immutable
class DatePick extends StatefulWidget {
  DatePick(
      String addr,
      String special,
      String evening,
      String morning,
      String uName,
      String appointMail,
      String appointeMail,
      String imgUrl,
      int j) {
    address = addr;
    specialisation = special;
    eveTime = evening.substring(11, 16) + " to " + evening.substring(31, 36);
    morTime = morning.substring(11, 16) + " to " + morning.substring(31, 36);
    userName = uName;
    appointerMail = appointMail;
    appointeeMail = appointeMail;
    imageUrl = imgUrl;
    i = j;
  }
  @override
  _DatePickState createState() => _DatePickState();
}

class _DatePickState extends State<DatePick> {
  // selectDate(BuildContext context) async {
  //   final DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDate: selectedDate,
  //       firstDate: DateTime(2020),
  //       lastDate: DateTime(2021),
  //       helpText: 'Select Appointment Date',
  //       cancelText: 'Not now',
  //       confirmText: 'Confirm');
  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = picked;
  //     });
  //   }
  //   print(picked);
  // }

  selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  void addAppointment(String username, String mail,
      String currentUserLoggedInMail, DateTime bookDate, int c) async {
    await Firestore.instance
        .collection('Appointments')
        .document(c.toString())
        .setData({
      'username': username,
      'email': mail,
      'currentEmail': currentUserLoggedInMail,
      'appointmentDate': DateFormat("yyyy-MM-dd HH:mm:ss").format(bookDate),
      'BookingTime': DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
      'Appointment_time': "not set yet",
      'Appointment_no': 0,
      'Appointment_prescription': "not uploaded yet",
      'id': c,
      'doctor_image': imageUrl
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Date'),
        backgroundColor: Colors.deepPurple,
        shadowColor: Colors.deepPurple,
        elevation: 10,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.deepPurple,
                      backgroundImage: imageUrl.compareTo(" ") == 0
                          ? null
                          : NetworkImage(imageUrl),
                    ),
                  ],
                ),
                Text(userName,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 32,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Morning Timings:",
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    Text("$morTime"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Evening Timings:",
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    Text("$eveTime"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Address:",
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    Text("$address"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Email:",
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    Text("$appointerMail"),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10),
                  child: Divider(thickness: 0.3, color: Colors.deepPurple),
                ),
              ],
            ),
            RaisedButton(
              elevation: 9.0,
              color: Colors.deepPurple,
              onPressed: () {
                selectDate(context);
              },
              child: Text(
                'Select date',
                style: TextStyle(color: Colors.white),
              ),
            ),
            RaisedButton(
              elevation: 9.0,
              color: Colors.deepPurple,
              onPressed: () {
                addAppointment(
                    userName, appointerMail, appointeeMail, selectedDate, i);
                Toast.show("Appointment Booked!!", context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
              },
              child: Text(
                'Book',
                style: TextStyle(color: Colors.white),
              ),
            ),
            RaisedButton(
              elevation: 9.0,
              color: Colors.deepPurple,
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Back',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
