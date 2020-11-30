import 'package:Appoint_Meet/appointmentsClass.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/services.dart';
//import 'package:intl/intl.dart';
import 'detailsClass.dart';
import 'package:flutter/material.dart';
import 'CarouselPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'datePick.dart';
//import 'package:image_downloader/image_downloader.dart';

String currentUserMail;
DateTime selectedDate;
int d = 0;
String time;
String t = " ";
String image = " ";
List<Details> detailList = [];

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
  }

  int len = 0;
  /*getuserImage(String mail) async {
    String image = " ";
    await Firestore.instance
        .collection("users")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      for (int i = 0; i < snapshot.documents.length; i++) {
        if (mail.compareTo(snapshot.documents[i]['email']) == 0) {
          image = snapshot.documents[i]['profile_image'];
        }
      }
    });
    return image;
  }*/

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
                        padding: const EdgeInsets.all(7.0),
                        child: Text(
                          "Upcoming Appointment at",
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
                            child: Text(t,
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
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
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
                              child: Text("Prescription")),
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
                          subtitle: Column(
                            children: [
                              Text(todaysAppointments[index].currentUserMail),
                              appointmentNoTime(todaysAppointments[index]),
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
                                  )
                                : CircleAvatar(
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
                  onTap: listitem.book == true
                      ? () {
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
                                        backgroundImage: listitem.imageUrl
                                                    .compareTo(" ") ==
                                                0
                                            ? AssetImage('images/logopng.png')
                                            : NetworkImage(listitem.imageUrl),
                                        //AssetImage('images/logopng.png'),
                                        //backgroundColor: Colors.deepPurple,
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
                                                    builder: (context) =>
                                                        DatePick(
                                                            listitem.imageUrl,
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
                        }
                      : () {
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text("not available")));
                        });
            });
  }
}
