class Appointments {
  //String userType;
  String userName;
  String email;
  String currentUserMail;
  DateTime bookedDate;
  DateTime bookingDate;
  //String userId;
  Appointments(this.userName, this.email, this.currentUserMail, this.bookedDate,
      this.bookingDate);

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

List<Appointments> appointmentsList = [];
List<Appointments> todaysAppointments = [];
void deleteDublicateAppointment() {
  int m = appointmentsList.length;
  for (int i = 0; i < m; i++) {
    DateTime n = appointmentsList[i].bookingDate;
    for (int j = i + 1; j < m; j++) {
      if (n == appointmentsList[j].bookingDate) {
        appointmentsList.removeAt(j);
        m--;
      }
    }
  }
}

void deleteDublicateTodaysAppointment() {
  int m = todaysAppointments.length;
  for (int i = 0; i < m; i++) {
    DateTime n = todaysAppointments[i].bookingDate;
    for (int j = i + 1; j < m; j++) {
      if (n == todaysAppointments[j].bookingDate) {
        todaysAppointments.removeAt(j);
        m--;
      }
    }
  }
}

void sortDate() {
  appointmentsList.sort((a, b) {
    if (a.bookedDate.compareTo(b.bookedDate) == 0) {
      return a.bookingDate.compareTo(b.bookingDate);
    }
    return a.bookedDate.compareTo(b.bookedDate);
  });
}

void sortList() {
  todaysAppointments.sort((a, b) => a.bookingDate.compareTo(b.bookingDate));
}
