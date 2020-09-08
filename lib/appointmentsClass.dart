class Appointments {
  //String userType;
  String userName;
  String email;
  //String userId;
  Appointments(this.userName, this.email);

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
void deleteDublicateAppointment() {
  int m = appointmentsList.length;
  for (int i = 0; i < m; i++) {
    String n = appointmentsList[i].userEmail;
    for (int j = i + 1; j < m; j++) {
      if (n == appointmentsList[j].userEmail) {
        appointmentsList.removeAt(j);
        m--;
      }
    }
  }
}
