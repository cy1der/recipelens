import 'package:flutter/material.dart';
import 'package:recipelens/pages/home_page.dart';
import 'package:recipelens/pages/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideDrawer extends StatelessWidget {
  final SharedPreferences prefs;
  const SideDrawer(this.prefs, {super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage(prefs))),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SettingsPage(prefs))),
          )
        ],
      ),
    );
  }
}
