import 'package:flutter/material.dart';
import 'package:recipelens/states/welcome_text_scroller_state.dart';

class WelcomeTextScroller extends StatefulWidget {
  final List<String> pages;

  const WelcomeTextScroller({Key? key, required this.pages}) : super(key: key);

  @override
  WelcomeTextScrollerState createState() => WelcomeTextScrollerState();
}
