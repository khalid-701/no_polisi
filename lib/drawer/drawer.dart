
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: (Column(
        //scrollDirection: Axis.vertical,
        children: [
          DrawerHeader(
              padding: EdgeInsets.zero,
              child: Container(
                decoration: BoxDecoration(gradient: SweepGradient(
                    colors: [Colors.red, Colors.yellow, Colors.purple])),
              )),
          ListTile(
            title: Text("Home"),
            leading: Icon(Icons.home),
            subtitle: Text("This our home"),
          ),
          ListTile(
            title: Text("Daftar Plat Nomor"),
            leading: Icon(Icons.list),
            onTap: () {
              Navigator.pushNamed(context, "list_page");
            },
          ),

          Divider(),
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: ListTile(
                title: Text("Logout"),
                leading: Icon(Icons.logout),
                onTap: () {
                  Navigator.pushReplacementNamed(context, "page_login");
                },
              ),
            ),
          ),
        ],
      )),
    );
  }
}

