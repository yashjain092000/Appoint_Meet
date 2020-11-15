import 'package:Appoint_Meet/myAppointments.dart';
import 'package:Appoint_Meet/updateProfileAppointee.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
//import 'UpdateProfileScreen.dart';
import 'SearchAppointer.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
          name: "Dashboard",
          baseStyle:
              TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 28.0),
          colorLineSelected: Colors.white,
        ),
        SearchBar()));
    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "My Appointments",
          baseStyle:
              TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 28.0),
          colorLineSelected: Colors.white,
        ),
        AppointmentsScreen()));

    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Settings",
          baseStyle:
              TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 28.0),
          colorLineSelected: Colors.white,
        ),
        UpdateProfileScreenAppointee()));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      elevationAppBar: 20,
      backgroundColorMenu: Colors.deepPurple,
      backgroundColorAppBar: Colors.deepPurple,
      disableAppBarDefault: false,
      actionsAppBar: <Widget>[
        DropdownButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          items: [
            DropdownMenuItem(
                child: Container(
                    child: Row(
                  children: <Widget>[
                    Icon(Icons.exit_to_app),
                    SizedBox(
                      width: 8,
                    ),
                    Text('LogOut!')
                  ],
                )),
                value: 'LogOut!'),
          ],
          onChanged: (itemIdentifier) {
            if (itemIdentifier == 'LogOut!') {
              FirebaseAuth.instance.signOut();
            }
          },
        ),
      ],
      screens: items,
    );
  }
}
