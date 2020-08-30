import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListTest extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Appointer Names'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              document['username'],
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xffdd),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Text(
              document['username'].toString(),
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ],
      ),
      onTap: () {
//print("should increase vots here");
// document.reference.updateData({
// 'votes': document['votes'] + 1
// }

// );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('Appointers').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('loading....');
            return ListView.builder(
              itemExtent: 80.0,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _buildListItem(context, snapshot.data.documents[index]),
            );
          }

// This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }
}
