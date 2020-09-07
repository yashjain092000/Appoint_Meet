import 'package:Appoint_Meet/SearchAppointer.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'secondScreen.dart';
//import 'CarouselPage.dart';
import 'firstScreen.dart';

class DashboardAppointee extends StatefulWidget {
  @override
  _DashboardAppointeeState createState() => _DashboardAppointeeState();
}

class _DashboardAppointeeState extends State<DashboardAppointee> {
  List<ScreenHiddenDrawer> items = new List();

  @override
  void initState() {
    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "first screen",
          baseStyle:
              TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 28.0),
          colorLineSelected: Colors.white,
        ),
        FirstScreen()));

    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "second screen",
          baseStyle:
              TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 28.0),
          colorLineSelected: Colors.white,
        ),
        SecondScreen()));
    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "search screen",
          baseStyle:
              TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 28.0),
          colorLineSelected: Colors.white,
        ),
        SearchCheck()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      elevationAppBar: 20,
      backgroundColorMenu: Colors.deepPurple,
      backgroundColorAppBar: Colors.deepPurple,
      disableAppBarDefault: true,
      screens: items,
    );
  }
}
