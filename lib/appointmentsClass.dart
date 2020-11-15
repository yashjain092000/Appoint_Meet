//import 'package:Appoint_Meet/mainDashboardAppointer.dart';

class Appointments {
  //String userType;
  String userName;
  String email;
  String currentUserMail;
  DateTime bookedDate;
  DateTime bookingDate;
  String id;
  //String userId;
  Appointments(this.userName, this.email, this.currentUserMail, this.bookedDate,
      this.bookingDate, this.id);

  String get userEmail => email;
  // String getUserType {
  //   return userType;
  // }

  // String get userEmail {
  //   return email;
  // }

  // String getUserName {
  //   return userName;
  // }

}

void deleteDublicateAppointment(List<Appointments> c) {
  int m = c.length;
  for (int i = 0; i < m; i++) {
    DateTime n = c[i].bookingDate;
    for (int j = i + 1; j < m; j++) {
      if (n == c[j].bookingDate) {
        c.removeAt(j);
        m--;
      }
    }
  }
}

/*void sortDate() {
  appointmentsList.sort((a, b) {
    if (a.bookedDate.compareTo(b.bookedDate) == 0) {
      return a.bookingDate.compareTo(b.bookingDate);
    }
    return a.bookedDate.compareTo(b.bookedDate);
  });
}*/

void sortList(List<Appointments> c) {
  c.sort((a, b) {
    if (a.bookedDate.compareTo(b.bookedDate) == 0) {
      return a.bookingDate.compareTo(b.bookingDate);
    }
    return a.bookedDate.compareTo(b.bookedDate);
  });
}
