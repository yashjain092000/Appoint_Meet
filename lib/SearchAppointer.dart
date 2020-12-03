import 'package:Appoint_Meet/appointmentsClass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'detailsClass.dart';
import 'package:flutter/material.dart';
import 'CarouselPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'datePick.dart';
import 'notification.dart';

String currentUserMail;
DateTime selectedDate;
int d = 0;
String time;
String t = " ";

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

  List<Appointments> todaysAppointments = [];
  void initState() {
    super.initState();
    getCurrentUserMail();
    Count().fillNoti();
  }

  int len = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisSize: MainAxisSize.min, children: [
        StreamBuilder(
            stream: Firestore.instance.collection('Appointers').snapshots(),
            builder: (ctx, streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final document = streamSnapshot.data.documents;

              for (int i = 0; i < document.length; i++) {
                detailList.add(new Details(
                    document[i]['specialisation'],
                    document[i]['username'],
                    document[i]['userEmail'],
                    document[i]['profile_image'],
                    document[i]['address'],
                    document[i]['morning_start_time'] +
                        " " +
                        document[i]['morning_end_time'],
                    document[i]['evening_start_time'] +
                        " " +
                        document[i]['evening_end_time'],
                    document[i]['canBook']));
              }
              deleteDublicate(detailList);
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              );
            }),
        AppBar(
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
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        CarouselPage(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        //getAppointerList,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 7.0, left: 7, right: 7, bottom: 3),
                        child: Text(
                          "Appointments",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.065,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
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
                        padding: const EdgeInsets.all(7.0),
                        child: Text(
                          "Total Appointments",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7.0),
                        child: Card(
                          color: Colors.deepPurple,
                          shadowColor: Colors.deepPurple[400],
                          elevation: 10.0,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(todaysAppointments.length.toString(),
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.08,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Divider(color: Colors.deepPurple, thickness: 0.4),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.003,
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
                          DateTime.parse(docu[i]['BookingTime']),
                          docu[i]['id'].toString()));
                    }
                  }
                }

                deleteDublicateAppointment(todaysAppointments);
                sortList(todaysAppointments);
                Widget appointmentNoTime(Appointments a) {
                  int n;
                  String g = '';
                  String prescription = " ";
                  for (int i = 0; i < docu.length; i++) {
                    if (a.bookingDate ==
                        DateTime.parse(docu[i]['BookingTime'])) {
                      n = docu[i]['Appointment_no'];
                      g = docu[i]['Appointment_time'];
                      prescription = docu[i]['Appointment_prescription'];
                    }
                  }
                  return Column(
                    children: [
                      Text("Appointment no.:" + n.toString() + " Time:" + g),
                      prescription.compareTo("not uploaded yet") == 0
                          ? Text(prescription)
                          : FlatButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (_) {
                                      return Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.6,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(prescription),
                                        ),
                                      );
                                    });
                              },
                              child: Text("View Prescription")),
                    ],
                  );
                }

                //print(todaysAppointments);
                return ListView.builder(
                    //shrinkWrap: true,
                    itemCount: todaysAppointments.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(todaysAppointments[index].email),
                          leading: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.deepPurple,
                            backgroundImage: null,
                          ),
                          subtitle: Column(
                            children: [
                              Text(todaysAppointments[index].currentUserMail),
                              appointmentNoTime(todaysAppointments[index]),
                            ],
                          ),
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
    //Widget a = getAppointerList;
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
                            child: listitem.imageUrl.compareTo(" ") == 0
                                ? CircleAvatar(
                                    child: Icon(Icons.portrait),
                                    backgroundColor: Colors.deepPurple,
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.deepPurple,
                                    backgroundImage:
                                        NetworkImage(listitem.imageUrl),
                                  )),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            child: Text(
                              listitem.userName,
                              style: TextStyle(fontSize: 20),
                            ),
                            shadowColor: Colors.deepPurple,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            child: Text(listitem.email,
                                style: TextStyle(fontSize: 20)),
                            shadowColor: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: listitem.book == true
                      ? () {
                          showModalBottomSheet(
                              elevation: 50.0,
                              enableDrag: true,
                              context: context,
                              builder: (_) {
                                return Column(
                                  children: [
                                    Container(
                                      height: 200,
                                      width: 200,
                                      padding: EdgeInsets.all(10.0),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.deepPurple,
                                        backgroundImage: listitem.imageUrl
                                                    .compareTo(" ") ==
                                                0
                                            ? null
                                            : NetworkImage(listitem.imageUrl),
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
                                      child: RaisedButton(
                                        elevation: 4.0,
                                        color: Colors.deepPurple,
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DatePick(
                                                          listitem.userName,
                                                          listitem.email,
                                                          currentUserMail,
                                                          listitem.imageUrl,
                                                          d)));
                                          d = d + 1;
                                        },
                                        child: Text(
                                          "Choose Date",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        }
                      : () {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                "Not available",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        });
            });
  }
}
