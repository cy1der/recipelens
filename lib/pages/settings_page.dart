import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipelens/states/settings_page_state.dart';

class SettingsPage extends StatefulWidget {
  final SharedPreferences prefs;
  const SettingsPage(this.prefs, {super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}
