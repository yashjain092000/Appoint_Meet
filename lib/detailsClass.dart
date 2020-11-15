class Details {
  String userType;
  String userName;
  String email;
  String imageUrl;
  bool book;
  Details(this.userType, this.userName, this.email, this.imageUrl, this.book);

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
        detailList[i].book = detailList[j].book;
        detailList.removeAt(j);
        m--;
      }
    }
  }
}
