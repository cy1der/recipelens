import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipelens/widgets/welcome_text_scroller.dart';

class WelcomeTextScrollerState extends State<WelcomeTextScroller> {
  final PageController _controller = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: _controller,
            itemCount: widget.pages.length,
            itemBuilder: (context, index) {
              return Center(
                  child: Text(widget.pages[index],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(color: Colors.white))));
            },
          ),
        ),
        DotsIndicator(
          dotsCount: widget.pages.length,
          position: _currentPage,
          decorator: const DotsDecorator(
              activeColor: Color.fromARGB(255, 214, 227, 217),
              color: Color.fromARGB(255, 99, 117, 102),
              size: Size(10, 10),
              activeSize: Size(10, 10)),
        ),
      ],
    );
  }
}
