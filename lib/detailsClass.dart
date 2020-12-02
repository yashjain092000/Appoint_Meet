class Details {
  String userSpecialisation;
  String userName;
  String email;
  String imageUrl;
  String address;
  String morningTime;
  String eveningTime;
  bool book;
  Details(this.userSpecialisation, this.userName, this.email, this.imageUrl,
      this.address, this.morningTime, this.eveningTime, this.book);
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
void deleteDublicate(List<Details> d) {
  int m = d.length;
  for (int i = 0; i < m; i++) {
    String n = d[i].email;
    for (int j = i + 1; j < m; j++) {
      if (n == d[j].email) {
        d[i].book = d[j].book;
        d[i].imageUrl = d[j].imageUrl;
        d.removeAt(j);
        m--;
      }
    }
  }
}
