import 'detailsClass.dart';
import 'package:flutter/material.dart';
import 'CarouselPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
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
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          getAppointerList,
          SizedBox(height: 50.0),
          CarouselPage(),
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
}
