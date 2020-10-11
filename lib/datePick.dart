import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime selectedDate = DateTime.now();
DateTime checkDate = DateTime.now();
String appointerMail;
String appointeeMail;
String userName;
DateTime bookingTime;

// ignore: must_be_immutable
class DatePick extends StatefulWidget {
  DatePick(String userName, String appointerMail, String appointeeMail) {
    userName = userName;
    appointerMail = appointerMail;
    appointeeMail = appointeeMail;
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
        helpText: 'Select booking Date',
        cancelText: 'Not now',
        confirmText: 'Confirm');
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
    print(selectedDate);
  }

  void addAppointment(String username, String mail,
      String currentUserLoggedInMail, DateTime bookDate) async {
    await Firestore.instance.collection('Appointments').document().setData({
      'username': username,
      'email': mail,
      'currentEmail': currentUserLoggedInMail,
      'appointmentDate': DateFormat("yyyy-MM-dd HH:mm:ss").format(bookDate),
      'BookingTime': DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RaisedButton(
              onPressed: () => selectDate(context),
              child: Text('Select date'),
            ),
            if (selectedDate != checkDate)
              RaisedButton(
                onPressed: () => addAppointment(
                    userName, appointerMail, appointeeMail, selectedDate),
                child: Text('Back'),
              ),
            RaisedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
