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

// ignore: must_be_immutable
class DatePick extends StatefulWidget {
  DatePick(String uName, String appointMail, String appointeMail, String imgUrl,
      int j) {
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
  selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2021),
        helpText: 'Select Appointment Date',
        cancelText: 'Not now',
        confirmText: 'Confirm');
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
    print(picked);
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
      'id': c
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
              children: [
                Row(
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
