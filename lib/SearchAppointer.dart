import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'detailsClass.dart';
import 'package:flutter/material.dart';
import 'CarouselPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'datePick.dart';

String currentUserMail;
DateTime selectedDate;

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentUserMail() async {
    final FirebaseUser user = await auth.currentUser();
    final uemail = user.email;
    setState(() {
      currentUserMail = uemail;
    });
  }

  void initState() {
    super.initState();
    getCurrentUserMail();
  }

  List<Details> todo = [
    new Details("Appointee", "Dr. Harry", "harry@gmail.com"),
    new Details("Appointee", "Dr. Abhishek", "abhishek@gmail.com"),
    new Details("Appointee", "Dr. Rishi", "rishi@gmail.com"),
    new Details("Appointee", "Dr. Susan", "susan@gmail.com"),
    new Details("Appointee", "Dr. Yash", "yash@gmail.com"),
    new Details("Appointee", "Dr. Shivam", "shivam@gmail.com"),
    new Details("Appointee", "Dr. Ishan", "ishan@gmail.com"),
    new Details("Appointee", "Dr. Rahul", "rahul@gmail.com"),
    new Details("Appointee", "Dr. Rishabh", "rishabh@gmail.com"),
  ];
  Widget getAppointerList = StreamBuilder(
      stream: Firestore.instance.collection('users').snapshots(),
      builder: (ctx, streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final document = streamSnapshot.data.documents;

        for (int i = 0; i < document.length; i++) {
          detailList.add(new Details(document[i]['typeUser'],
              document[i]['username'], document[i]['email']));
        }
        deleteDublicate();

        return Text('');
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 20.0,
          title: Text('Search Appointers',
              style:
                  TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: AppointerNameSearch());
              },
              icon: Icon(Icons.search, color: Colors.deepPurple),
            ),
          ]),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 30,
          ),
          CarouselPage(),
          getAppointerList,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Card(
                    color: Colors.white,
                    shadowColor: Colors.deepPurple[400],
                    elevation: 10.0,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text(
                            "Upcoming Appointment at",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14.0),
                          child: Card(
                            color: Colors.deepPurple,
                            shadowColor: Colors.deepPurple[400],
                            elevation: 10.0,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("2:33 pm",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Column(
                children: [
                  Card(
                    color: Colors.white,
                    shadowColor: Colors.deepPurple[400],
                    elevation: 10.0,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Total Appointments",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14.0),
                          child: Card(
                            color: Colors.deepPurple,
                            shadowColor: Colors.deepPurple[400],
                            elevation: 10.0,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("11",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: todo.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 10.0,
                      shadowColor: Colors.deepPurple[400],
                      color: Colors.white,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          radius: 35,
                          child: Text(
                            todo[index].userName[0].toUpperCase() +
                                todo[index].userName[4].toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Center(child: Text(todo[index].userName)),
                        subtitle: Center(child: Text(todo[index].email)),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (_) {
                                return Column(
                                  children: [
                                    Container(
                                      height: 200,
                                      width: 200,
                                      padding: EdgeInsets.all(10.0),
                                      child: CircleAvatar(
                                        backgroundImage:
                                            AssetImage('images/logopng.png'),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 10.0,
                                          bottom: 10.0,
                                          left: 30,
                                          right: 30.0),
                                      child: Card(
                                        child: Text(
                                          todo[index].userName,
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        shadowColor: Colors.purple,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 10.0,
                                          bottom: 10.0,
                                          left: 30,
                                          right: 30.0),
                                      child: Card(
                                        child: Text(todo[index].email,
                                            style: TextStyle(fontSize: 30)),
                                        shadowColor: Colors.purple,
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}

class AppointerNameSearch extends SearchDelegate<Details> {
  void addAppointment(String username, String mail,
      String currentUserLoggedInMail, String bookDate, String bookTime) async {
    await Firestore.instance.collection('Appointments').document().setData({
      'username': username,
      'email': mail,
      'currentEmail': currentUserLoggedInMail,
      'bookedDate': selectedDate,
      'dateOfBooking': bookTime
    });
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back),
        color: Colors.deepPurple);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        color: Colors.deepPurple,
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchBar();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final mylist = query.isEmpty
        ? detailList
        : detailList.where((p) => p.userName.startsWith(query)).toList();
    return mylist.isEmpty
        ? Text(
            'No results Found!!...',
          )
        : GridView.builder(
            itemCount: mylist.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                childAspectRatio: 0.65),
            itemBuilder: (context, index) {
              final Details listitem = mylist[index];
              return InkWell(
                child: Card(
                  color: Colors.white10,
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        padding: EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          backgroundImage: AssetImage('images/logopng.png'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          child: Text(
                            listitem.userName,
                            style: TextStyle(fontSize: 20),
                          ),
                          shadowColor: Colors.purple,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          child: Text(listitem.email,
                              style: TextStyle(fontSize: 20)),
                          shadowColor: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return Column(
                          children: [
                            Container(
                              height: 200,
                              width: 200,
                              padding: EdgeInsets.all(10.0),
                              child: CircleAvatar(
                                // backgroundImage:
                                //AssetImage('images/logopng.png'),
                                backgroundColor: Colors.deepPurple,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Card(
                                child: Text(
                                  listitem.userName,
                                  style: TextStyle(fontSize: 30),
                                ),
                                shadowColor: Colors.deepPurple,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Card(
                                child: Text(listitem.email,
                                    style: TextStyle(fontSize: 30)),
                                shadowColor: Colors.deepPurple,
                              ),
                            ),
                            Card(
                              child: FlatButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DatePick(
                                                listitem.userName,
                                                listitem.email,
                                                currentUserMail)));
                                  },
                                  child: Text("Choose Date")),
                            ),
                            Card(
                              child: FlatButton(
                                  onPressed: () {
                                    print(currentUserMail);
                                    print(selectedDate);
                                    addAppointment(
                                      listitem.userName,
                                      listitem.email,
                                      currentUserMail,
                                      DateFormat("yyyy-MM-dd HH:mm:ss")
                                          .format(selectedDate),
                                      DateFormat("yyyy-MM-dd HH:mm:ss")
                                          .format(DateTime.now()),
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Book")),
                            )
                          ],
                        );
                      });
                },
              );
            });
  }
}
