import 'package:flutter/material.dart';
import 'package:recipelens/pages/welcome_page.dart';
import 'package:recipelens/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(RecipeLens(prefs));
}

class RecipeLens extends StatelessWidget {
  final SharedPreferences prefs;

  const RecipeLens(this.prefs, {super.key});

  @override
  Widget build(BuildContext context) {
    bool welcomeShown = prefs.getBool('welcome_shown') ?? false;

    Widget startPage = WelcomePage(prefs);

    if (welcomeShown) startPage = HomePage(prefs);

    return MaterialApp(
        title: 'Recipe Lens',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
        ),
        home: startPage);
  }
}
