import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    //scaffold
    return Scaffold(
      backgroundColor: Colors.white,
      //main body
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 180, bottom: 10, left: 10, right: 10),
            child: Row(
              children: <Widget>[
                Image(
                  image: AssetImage('images/logopng.png'),
                  height: 100,
                ),
                Text(
                  "APPOINT",
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(
                  width: 20.0,
                  height: 100.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
