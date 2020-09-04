import 'detailsClass.dart';

List<Details> detailList = [];
void deleteDublicate() {
  int m = detailList.length;
  for (int i = 0; i < m; i++) {
    String n = detailList[i].userEmail;
    for (int j = i + 1; j < m; j++) {
      if (n == detailList[j].userEmail) {
        detailList.removeAt(j);
        m--;
      }
    }
  }
}

bool once = false;
