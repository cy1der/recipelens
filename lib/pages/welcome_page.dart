import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipelens/pages/home_page.dart';
import 'package:recipelens/widgets/welcome_text_scroller.dart';
import 'dart:ui';

class WelcomePage extends StatelessWidget {
  final SharedPreferences prefs;

  const WelcomePage(this.prefs, {super.key});

  void completeSetup() => prefs.setBool('welcome_shown', true);

  @override
  Widget build(BuildContext context) {
    final List<String> scrollerPages = [
      'Relax, let RecipeLens pick the perfect recipe for you!',
      'Just enter the foods you have at home, and you will get a list of recipes you can cook!',
      "Perfect for those 'I don't know what to eat' and 'Make me whatever' moments!"
    ];

    return Material(
        child: Center(
            child: Stack(
      children: [
        Positioned.fill(
            child: SvgPicture.asset(
          'assets/images/bg.svg',
          semanticsLabel: 'Background',
          fit: BoxFit.fill,
        )),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
          child: Container(
            color: Colors.black.withOpacity(0),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(flex: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Recipe',
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            color: Color.fromARGB(255, 74, 109, 81),
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            shadows: [
                          Shadow(
                              color: Color.fromARGB(51, 0, 0, 0),
                              offset: Offset(-3, 4),
                              blurRadius: 2)
                        ]))),
                Text('Lens',
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            shadows: [
                          Shadow(
                              color: Color.fromARGB(51, 0, 0, 0),
                              offset: Offset(-3, 4),
                              blurRadius: 4)
                        ])))
              ],
            ),
            const Spacer(),
            SvgPicture.asset(
              'assets/images/logo.svg',
              semanticsLabel: 'RecipeLens Logo',
              height: 200,
              width: 200,
            ),
            const Spacer(flex: 1),
            Text(
              'WELCOME',
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      shadows: [
                    Shadow(
                        color: Color.fromARGB(51, 0, 0, 0),
                        offset: Offset(-3, 4),
                        blurRadius: 4)
                  ])),
            ),
            SizedBox(
              width: 250,
              height: 110,
              child: WelcomeTextScroller(pages: scrollerPages),
            ),
            const Spacer(flex: 2),
            TextButton(
              onPressed: () {
                completeSetup();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomePage(prefs)));
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 74, 109, 81)),
                  padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 25, vertical: 15)),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))))),
              child: Text(
                'Get Started',
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 30)),
              ),
            ),
            const Spacer(flex: 10)
          ],
        )
      ],
    )));
  }
}
