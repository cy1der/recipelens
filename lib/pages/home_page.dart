import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipelens/states/home_page_state.dart';

class HomePage extends StatefulWidget {
  final SharedPreferences prefs;

  const HomePage(this.prefs, {super.key});

  @override
  HomePageState createState() => HomePageState();
}
