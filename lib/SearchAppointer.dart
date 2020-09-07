import 'detailsClass.dart';
import 'package:flutter/material.dart';
import 'firstScreen.dart';
import 'CarouselPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  List<Details> todo = [
    new Details("Appointee", "Harry", "harry@gmail.com"),
    new Details("Appointee", "Abhishek", "abhishek@gmail.com"),
    new Details("Appointee", "Rishi", "rishi@gmail.com"),
    new Details("Appointee", "Susan", "susan@gmail.com"),
    new Details("Appointee", "Yash", "yash@gmail.com"),
    new Details("Appointee", "Shivam", "shivam@gmail.com"),
    new Details("Appointee", "Ishan", "ishan@gmail.com"),
    new Details("Appointee", "Rahul", "rahul@gmail.com"),
    new Details("Appointee", "Rishabh", "rishabh@gmail.com"),
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

        return SizedBox(
          height: 10,
        );
      });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Search Appointers'),
          backgroundColor: Colors.blue,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: AppointerNameSearch());
              },
              icon: Icon(Icons.search, color: Colors.deepPurple),
            )
          ]),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 10,
          ),
          CarouselPage(),
          getAppointerList,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    "Next Appointment At",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Card(
                      color: Colors.deepPurple,
                      shadowColor: Colors.deepPurple[400],
                      elevation: 10.0,
                      child: Text("2:30 pm",
                          style: TextStyle(fontSize: 25, color: Colors.white)),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Text("Appointments to take", style: TextStyle(fontSize: 20)),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Card(
                        color: Colors.deepPurple,
                        //margin: EdgeInsets.all(10),
                        shadowColor: Colors.deepPurple[400],
                        elevation: 10.0,
                        child: Text("10",
                            style:
                                TextStyle(fontSize: 25, color: Colors.white)),
                      ),
                    ),
                  )
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
                                      padding: const EdgeInsets.all(10.0),
                                      child: Card(
                                        child: Text(
                                          todo[index].userName,
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        shadowColor: Colors.purple,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
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
  Widget buildResults(BuildContext context) {
    return FirstScreen();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final mylist = query.isEmpty
        ? detailList
        : detailList.where((p) => p.userName.startsWith(query)).toList();
    return mylist.isEmpty
        ? Text('No results Found!!......')
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
                                backgroundImage:
                                    AssetImage('images/logopng.png'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Card(
                                child: Text(
                                  listitem.userName,
                                  style: TextStyle(fontSize: 30),
                                ),
                                shadowColor: Colors.purple,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Card(
                                child: Text(listitem.email,
                                    style: TextStyle(fontSize: 30)),
                                shadowColor: Colors.purple,
                              ),
                            ),
                          ],
                        );
                      });
                },
              );
            });
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return null;
  }
}
