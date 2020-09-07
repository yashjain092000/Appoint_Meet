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

        return Text('halwa');
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
        children: [Text("to kese hap"), CarouselPage(), getAppointerList],
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
        : ListView.builder(
            itemCount: mylist.length,
            itemBuilder: (context, index) {
              final Details listitem = mylist[index];
              return ListTile(
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
                title: Column(
                  children: [
                    Text(listitem.userName),
                    Text(listitem.email),
                    Divider(),
                  ],
                ),
              );
            });
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return null;
  }
}
