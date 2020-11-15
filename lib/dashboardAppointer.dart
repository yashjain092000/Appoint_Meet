import 'package:Appoint_Meet/mainDashboardAppointer.dart';
import 'package:Appoint_Meet/previousAppointments.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'UpdateProfileScreen.dart';
//import 'CarouselPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
          name: "DashBoard",
          baseStyle:
              TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 28.0),
          colorLineSelected: Colors.teal,
        ),
        MainDash()));

    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Past Appointments",
          baseStyle:
              TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 28.0),
          colorLineSelected: Colors.teal,
        ),
        PreviousAppointmentsScreen()));

    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Update Profile",
          baseStyle:
              TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 28.0),
          colorLineSelected: Colors.orange,
        ),
        UpdateProfileScreen()));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Colors.blueGrey,
      backgroundColorAppBar: Colors.cyan,
      disableAppBarDefault: false,
      screens: items,
      actionsAppBar: [
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
    );
  }
}
