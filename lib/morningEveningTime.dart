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

List<TimeTable> doctorsTimeTable = [];
void deleteDuplicateDoctor() {
  int m = doctorsTimeTable.length;
  for (int i = 0; i < m; i++) {
    for (int j = i + 1; j < m; j++) {
      if (doctorsTimeTable[i]
              .doctorsMail
              .compareTo(doctorsTimeTable[j].doctorsMail) ==
          0) {
        doctorsTimeTable.removeAt(j);
      }
    }
  }
}
