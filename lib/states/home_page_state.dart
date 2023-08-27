import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:recipelens/pages/home_page.dart';
import 'package:recipelens/pages/search_foods_page.dart';
import 'package:recipelens/util/rec_image.dart';
import 'package:recipelens/util/recipe.dart';
import 'package:recipelens/util/title.dart';
import 'package:recipelens/widgets/side_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePageState extends State<HomePage> {
  Future<void> _openLink(Uri link) async {
    if (await canLaunchUrl(link)) {
      await launchUrl(link);
    } else {
      throw 'Could not launch $link';
    }
  }

  FlutterTts flutterTts = FlutterTts();
  String selectedAdditionalInfo = 'Option 1';
  bool _isExpanded = false;

  List<Recipe> recipes = [];
  List<RecipeTitle> titles = [];
  List<RecImage> images = [];

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  void speakText(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.speak(text);
  }

  Future<void> _searchRecipes(List<String> ingredients) async {
    try {
      final apiKey = widget.prefs.getString('spoon_api_key') ??
          (dotenv.env['SPOON_API_KEY'] ?? '');
      final joinedIngredients = ingredients.join(',');
      final response = await http.get(
        Uri.parse(
            'https://api.spoonacular.com/recipes/findByIngredients?apiKey=$apiKey&ingredients=$joinedIngredients'),
      );
      var jsonData = jsonDecode(response.body);

      for (var eachRecipeName in jsonData) {
        final recipeTitle = RecipeTitle(
          title: eachRecipeName['title'],
        );
        titles.add(recipeTitle);
        final recImage = RecImage(
          image: eachRecipeName['image'],
        );
        images.add(recImage);
      }

      if (response.statusCode == 200) {
        final List<dynamic> recipesData = json.decode(response.body);
        final List<Recipe> fetchedRecipes = recipesData.map((data) {
          return Recipe(data['title'], data['description']);
        }).toList();

        setState(() {
          recipes = fetchedRecipes;
        });
      } else {
        // Handle errors
      }
    } catch (e) {
      // Handle exceptions
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> ingredients = widget.prefs.getStringList('ingredients') ?? [];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 240, 234),
      drawer: SideDrawer(widget.prefs),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add food',
        backgroundColor: const Color.fromARGB(255, 99, 165, 118),
        foregroundColor: Colors.black,
        onPressed: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SearchFoodsPage(widget.prefs),
          ),
        ),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Recipe',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: Color.fromARGB(255, 74, 109, 81),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              'Lens',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
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
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ingredients',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 74, 109, 81),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 214, 239, 219),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: ingredients.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          trailing: IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Deleted ${ingredients[index]}',
                                  ),
                                ),
                              );
                              setState(() {
                                ingredients.removeAt(index);
                              });
                              widget.prefs.setStringList(
                                'ingredients',
                                ingredients,
                              );
                            },
                            color: Colors.red,
                            icon: const Icon(Icons.delete),
                          ),
                          textColor: Colors.black,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          title: Text(
                            ingredients[index],
                            style: GoogleFonts.poppins(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _searchRecipes(ingredients);
                  },
                  child: const Text('Search Recipes'),
                ),
                const SizedBox(height: 16),
                ExpansionPanelList(
                  elevation: 0,
                  expandedHeaderPadding: EdgeInsets.zero,
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  children: [
                    ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return GestureDetector(
                          onTap: () {
                            speakText('Welcome to Recipe Lens.');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Recipes ------------------>',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: const Color.fromARGB(255, 74, 109, 81),
                              ),
                            ),
                          ),
                        );
                      },
                      body: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Press the 'Search Recipes' button to find new recipes!",
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                      isExpanded: _isExpanded,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ExpansionPanelList(
                  elevation: 1,
                  expandedHeaderPadding: EdgeInsets.zero,
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  children: titles.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final RecipeTitle title = entry.value;
                    final RecImage image = images[index];
                    return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return GestureDetector(
                          onTap: () {
                            speakText(title.title);
                            String testTitle = (title.title);
                            String testImage = (image.image);
                            String stringWithHyphens =
                                testTitle.replaceAll(' ', '-');
                            String substring = testImage.substring(37, 43);
                            String concatUrl =
                                'https://spoonacular.com/recipes/$stringWithHyphens-$substring';
                            Uri clickUrl = Uri.parse(concatUrl);
                            _openLink(clickUrl);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              title.title,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: const Color.fromARGB(255, 74, 109, 81),
                              ),
                            ),
                          ),
                        );
                      },
                      body: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title.title,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: Image.network(
                                image.image,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      isExpanded: _isExpanded,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
