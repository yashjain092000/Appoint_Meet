class Details {
  String userType;
  String userName;
  String email;
  Details(this.userType, this.userName, this.email);

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
