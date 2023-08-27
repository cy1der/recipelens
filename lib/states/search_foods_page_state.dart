import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipelens/backend/edamam_food_client.dart';
import 'package:recipelens/pages/home_page.dart';
import 'package:recipelens/pages/search_foods_page.dart';
import 'package:recipelens/util/api_result.dart';
import 'package:recipelens/widgets/side_drawer.dart';

class SearchFoodsPageState extends State<SearchFoodsPage> {
  final TextEditingController searchController = TextEditingController();
  List<String> suggestions = [];

  @override
  Widget build(BuildContext context) {
    EdamamFoodClient client = EdamamFoodClient(widget.prefs);
    List<String> ingredientsList =
        widget.prefs.getStringList('ingredients') ?? [];

    void fetchSuggestions(String query) async {
      ApiResult response = await client.autocomplete(query);

      if (response.type == ApiResultType.success) {
        setState(() {
          suggestions = List<String>.from(response.data);
        });
      }
    }

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 234, 240, 234),
        drawer: SideDrawer(widget.prefs),
        appBar: AppBar(
            titleSpacing: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Food Search',
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
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 214, 239, 219),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        cursorColor: Colors.black,
                        maxLines: 1,
                        autofocus: true,
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        )),
                        controller: searchController,
                        onChanged: (query) {
                          if (query.isNotEmpty) {
                            fetchSuggestions(query);
                          } else {
                            setState(() {
                              suggestions = [];
                            });
                          }
                        },
                        decoration: const InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.search, color: Colors.black),
                            border: InputBorder.none),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Color.fromARGB(255, 214, 239, 219)),
                      child: SizedBox(
                        height: 280,
                        child: ListView.builder(
                          itemCount: suggestions.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              textColor: Colors.black,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              title: Text(
                                suggestions[index],
                                style: GoogleFonts.poppins(),
                              ),
                              onTap: () =>
                                  searchController.text = suggestions[index],
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 74, 109, 81),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomePage(widget.prefs)));
                            },
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                fixedSize: const Size(105, 25)),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      fontSize: 18, color: Colors.white)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 74, 109, 81),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextButton(
                            onPressed: () {
                              String ingredient = searchController.text.trim();
                              setState(() {
                                if (ingredient.isNotEmpty) {
                                  ingredientsList.add(ingredient);
                                }
                              });

                              //print('Ingredients List after adding: $ingredientsList');
                              widget.prefs.setStringList(
                                  'ingredients', ingredientsList);
                            },
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                fixedSize: const Size(105, 25)),
                            child: Text(
                              'Add',
                              style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      fontSize: 18, color: Colors.white)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          )
        ]));
  }
}
