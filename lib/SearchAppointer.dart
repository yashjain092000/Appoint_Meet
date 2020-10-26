import 'package:Appoint_Meet/appointmentsClass.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/services.dart';
//import 'package:intl/intl.dart';
import 'detailsClass.dart';
import 'package:flutter/material.dart';
import 'CarouselPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'datePick.dart';

String currentUserMail;
DateTime selectedDate;
int d = 0;
String time;

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
  /*setAppointmentTime(String pa,String doc) async {
    await Firestore.instance
        .collection("Appointments")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      for (int i = 0; i < snapshot.documents.length; i++) {
        //print(snapshot.documents[i]['userEmail']);
        if(pa.compareTo(snapshot.documents[i]['userEmail'])==0 && doc.compareTo(snapshot.documents[i]))
      }
    });*/

  List<Appointments> todaysAppointments = [];
  void initState() {
    super.initState();
    getCurrentUserMail();
  }

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
  /*Widget getAppointmentsList = StreamBuilder(
      stream: Firestore.instance.collection('Appointments').snapshots(),
      builder: (ctx, streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final docu = streamSnapshot.data.documents;

        for (int i = 0; i < docu.length; i++) {
          if (docu[i]['currentEmail'] == currentUserMail) {
            if (DateTime.parse(docu[i]['appointmentDate']).day ==
                DateTime.now().day) {
              todaysAppointments.add(new Appointments(
                  docu[i]['username'],
                  docu[i]['email'],
                  currentUserMail,
                  DateTime.parse(docu[i]['appointmentDate']),
                  DateTime.parse(docu[i]['BookingTime'])));
            }
          }
        }
        deleteDublicateTodaysAppointment();

        return Text('');
      });*/
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
      body: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(
          height: 30,
        ),
        CarouselPage(),
        getAppointerList,
        //getAppointmentsList,
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
                            child: Text("10:00 am",
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
                            child: Text(todaysAppointments.length.toString(),
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
          child: StreamBuilder(
              stream: Firestore.instance.collection('Appointments').snapshots(),
              builder: (ctx, streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final docu = streamSnapshot.data.documents;

                for (int i = 0; i < docu.length; i++) {
                  if (docu[i]['currentEmail'] == currentUserMail) {
                    if (DateTime.parse(docu[i]['appointmentDate']).day >=
                        DateTime.now().day) {
                      todaysAppointments.add(new Appointments(
                          docu[i]['username'],
                          docu[i]['email'],
                          currentUserMail,
                          DateTime.parse(docu[i]['appointmentDate']),
                          DateTime.parse(docu[i]['BookingTime'])));
                    }
                  }
                }

                deleteDublicateAppointment(todaysAppointments);
                sortList(todaysAppointments);
                Widget appointmentNo(Appointments a) {
                  int n;
                  for (int i = 0; i < docu.length; i++) {
                    if (a.bookingDate ==
                        DateTime.parse(docu[i]['BookingTime'])) {
                      n = docu[i]['Appointment_no'];
                    }
                  }
                  return Text(n.toString());
                }

                //print(todaysAppointments);
                return ListView.builder(
                    //shrinkWrap: true,
                    itemCount: todaysAppointments.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(todaysAppointments[index].email),
                          subtitle: Column(
                            children: [
                              Text(todaysAppointments[index].currentUserMail),
                              appointmentNo(todaysAppointments[index]),
                            ],
                          ),
                          //trailing: appointmentNo(todaysAppointments[i]),
                        ),
                      );
                    });
              }),
        ),
      ]),
    );
  }
}

class AppointerNameSearch extends SearchDelegate<Details> {
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
                                                currentUserMail,
                                                d)));
                                    d = d + 1;
                                  },
                                  child: Text("Choose Date")),
                            ),
                            // Card(
                            //   child: FlatButton(
                            //       onPressed: () {
                            //         print(currentUserMail);
                            //         print(selectedDate);
                            //         addAppointment(
                            //           listitem.userName,
                            //           listitem.email,
                            //           currentUserMail,
                            //           DateFormat("yyyy-MM-dd HH:mm:ss")
                            //               .format(selectedDate),
                            //           DateFormat("yyyy-MM-dd HH:mm:ss")
                            //               .format(DateTime.now()),
                            //         );
                            //         Navigator.of(context).pop();
                            //       },
                            //       child: Text("Book")),
                            // )
                          ],
                        );
                      });
                },
              );
            });
  }
}
