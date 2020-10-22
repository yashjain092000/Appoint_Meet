class TimeTable {
  String doctorsMail;
  DateTime morningStartTime;
  DateTime eveningStartTime;
  DateTime morningEndTime;
  DateTime eveningEndTime;
  int pTime;
  TimeTable(this.doctorsMail, this.morningStartTime, this.morningEndTime,
      this.eveningStartTime, this.eveningEndTime, this.pTime);
}

//List<TimeTable> doctorsTimeTable = [];
void deleteDuplicateDoctor(List<TimeTable> c) {
  int m = c.length;
  for (int i = 0; i < m; i++) {
    for (int j = i + 1; j < m; j++) {
      if (c[i].doctorsMail.compareTo(c[j].doctorsMail) == 0) {
        c.removeAt(j);
      }
    }
  }
}

double total(List<TimeTable> b, String c) {
  double d;
  for (int i = 0; i < b.length; i++) {
    if (b[i].doctorsMail == c) {
      d = ((b[i].morningEndTime.hour - b[i].morningStartTime.hour) * 60) /
              b[i].pTime +
          ((b[i].eveningEndTime.hour - b[i].eveningStartTime.hour) * 60) /
              b[i].pTime;
      print(d);
    }
  }
  return d;
}
