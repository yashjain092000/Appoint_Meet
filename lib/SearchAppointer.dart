import 'detailsClass.dart';
import 'package:flutter/material.dart';
import 'firstScreen.dart';
import 'detailList.dart';

class SearchCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Search Food Items'),
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
        children: [Text("to kese hap")],
      ),
    );
  }
}

class AppointerNameSearch extends SearchDelegate<Details> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
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
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
                childAspectRatio: 0.6),
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
                  //showResults(context);
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
