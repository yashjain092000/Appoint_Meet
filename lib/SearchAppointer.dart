import 'package:demo/detailsClass.dart';
import 'package:flutter/material.dart';
//import 'ListClass.dart';
import 'firstScreen.dart';
import 'detailList.dart';

class SearchCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Search Food Items'),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: FoodItemsSearch());
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

class FoodItemsSearch extends SearchDelegate<Details> {
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
        ? Text('No results Found!!.......')
        : ListView.builder(
            itemCount: mylist.length,
            itemBuilder: (context, index) {
              final Details listitem = mylist[index];
              return ListTile(
                onTap: () {
                  showResults(context);
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
}
