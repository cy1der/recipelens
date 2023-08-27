import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipelens/pages/settings_page.dart';
import 'package:recipelens/widgets/side_drawer.dart';

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideDrawer(widget.prefs),
        appBar: AppBar(
            titleSpacing: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Settings',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            )),
        body: Stack(children: [
          Stack(
            children: [
              Positioned(
                top: -10,
                left: -40,
                child: SvgPicture.asset(
                  'assets/images/ellipse1.svg',
                  width: 100,
                  height: 100,
                ),
              ),
              Positioned(
                top: -40,
                left: 5,
                child: SvgPicture.asset(
                  'assets/images/ellipse2.svg',
                  width: 100,
                  height: 100,
                ),
              ),
              Positioned(
                bottom: -10,
                right: -40,
                child: SvgPicture.asset(
                  'assets/images/ellipse1.svg',
                  width: 100,
                  height: 100,
                ),
              ),
              Positioned(
                bottom: -40,
                right: 5,
                child: SvgPicture.asset(
                  'assets/images/ellipse2.svg',
                  width: 100,
                  height: 100,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // settings go here
                    Center(
                      child: Text('settings page'),
                    )
                  ],
                ),
              )
            ],
          )
        ]));
  }
}
