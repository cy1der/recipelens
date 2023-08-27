import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipelens/states/search_foods_page_state.dart';

class SearchFoodsPage extends StatefulWidget {
  final SharedPreferences prefs;
  const SearchFoodsPage(this.prefs, {super.key});

  @override
  SearchFoodsPageState createState() => SearchFoodsPageState();
}
