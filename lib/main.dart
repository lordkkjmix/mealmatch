import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mealmatch/recipe_detail.dart';
import 'package:mealmatch/recipes_list_screen.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MealMashApp());
}

class MealMashApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealMash',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: IngredientSelectionScreen(),
    );
  }
}

class IngredientSelectionScreen extends StatefulWidget {
  @override
  _IngredientSelectionScreenState createState() =>
      _IngredientSelectionScreenState();
}

class _IngredientSelectionScreenState extends State<IngredientSelectionScreen> {
  List<String> _selectedIngredients = [];
  List<String> _allIngredients = [];
  List<String> _filteredIngredients = [];
  bool isLoading = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getIngredients();
  }

  void getIngredients() async {
    setState(() {
      isLoading = true;
    });
    try {
      const apiUrl =
          'http://192.168.1.133:8000/ingredients'; // Replace with your API endpoint

      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List res = data['ingredients'];
        setState(() {
          _allIngredients = res.map((e) => e.toString()).toList();
          isLoading = false;
        });
      } else {}
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Failed to fetch recipes. Error: ${e}');
    }
  }

  void _searchIngredients(String query) {
    setState(() {
      _filteredIngredients = _allIngredients
          .where((ingredient) =>
              ingredient.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _selectIngredient(String ingredient) {
    setState(() {
      _selectedIngredients.add(ingredient);
    });
  }

  void _deselectIngredient(String ingredient) {
    setState(() {
      _selectedIngredients.remove(ingredient);
    });
  }

  void _navigateToRecipeListScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeListScreen(
          selectedIngredients: _selectedIngredients,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    const Text(
                      "Choisissez vos \ningrédients",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 10.0),
                      child: TextField(
                        style: const TextStyle(fontSize: 16.0),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor:
                              Colors.grey[200], // Set the background color
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1.0), // Set the default border color
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          prefixIcon:
                              const Icon(Icons.search), // Set the prefix icon
                          hintText: 'Recherche rapide', // Set the placeholder
                          hintStyle: const TextStyle(fontSize: 16.0),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                        ),
                        controller: _searchController,
                        onChanged: _searchIngredients,
                      ),
                    ),
                  ],
                ),
              ),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _allIngredients.length,
                        itemBuilder: (context, index) {
                          final ingredient = _allIngredients[index];
                          final isSelected =
                              _selectedIngredients.contains(ingredient);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: ListTile(
                              onTap: () => isSelected
                                  ? _deselectIngredient(ingredient)
                                  : _selectIngredient(ingredient),
                              // Set the tile background color
                              // Set the tile content padding
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.black,
                                    width:
                                        1.0), // Set the tile border color and width
                                borderRadius: BorderRadius.circular(
                                    8.0), // Set the tile border radius
                              ),
                              leading:
                                  const FlutterLogo() /* Image.asset() */, // Set the image on the leading
                              title: Text(ingredient), // Set the title
                              /* subtitle:
                                  const Text('Your Subtitle'), */ // Set the subtitle
                              trailing: Checkbox(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                onChanged: (v) => isSelected
                                    ? _deselectIngredient(ingredient)
                                    : _selectIngredient(ingredient),
                                value:
                                    isSelected, // Set the checkbox onChanged callback
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              isLoading
                  ? Container()
                  : Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Theme.of(context).primaryColor,
                          minimumSize:
                              Size(MediaQuery.of(context).size.width, 50),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        onPressed: _navigateToRecipeListScreen,
                        child: const Text('Trouver des plats'),
                      ),
                    ),
            ],
          ),
        ));
  }
}

class Recipe {
  final String label;
  final String description;
  final String? difficulty;
  final String? timeToCook;
  final String image;

  Recipe({
    required this.label,
    required this.description,
    this.difficulty,
    this.timeToCook,
    required this.image,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      label: json['recipe_name'],
      description: json['recipe_details'],
      difficulty: json['difficulty'],
      timeToCook: json['timeToCook'],
      image: json['recipe_image'],
    );
  }
}
