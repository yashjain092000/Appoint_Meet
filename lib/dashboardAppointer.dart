import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'firstScreen.dart';
import 'CarouselPage.dart';

class DashboardAppointer extends StatefulWidget {
  @override
  _DashboardAppointerState createState() => _DashboardAppointerState();
}

class _DashboardAppointerState extends State<DashboardAppointer> {
  List<ScreenHiddenDrawer> items = new List();

  @override
  void initState() {
    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Screen 1 Appointer",
          baseStyle:
              TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 28.0),
          colorLineSelected: Colors.teal,
        ),
        CarouselPage()));

    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Screen 2 Appointer",
          baseStyle:
              TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 28.0),
          colorLineSelected: Colors.orange,
        ),
        FirstScreen()));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Colors.blueGrey,
      backgroundColorAppBar: Colors.cyan,
      disableAppBarDefault: true,
      screens: items,
    );
  }
}
