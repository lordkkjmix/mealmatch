import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mealmatch/main.dart';
import 'package:mealmatch/recipe_detail.dart';
import 'package:http/http.dart' as http;

class RecipeListScreen extends StatefulWidget {
  final List<String> selectedIngredients;

  const RecipeListScreen({super.key, required this.selectedIngredients});

  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final List<Recipe> _recipes = [];
  List<Recipe> _filteredRecipes = [];

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  void _fetchRecipes() async {
    const apiUrl =
        'http://192.168.1.133:8000/meal/discover'; // Replace with your API endpoint
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'ingredients': widget.selectedIngredients.join(",")
    }); // Encode selected ingredients as JSON body

    /*  final response = await http
        .post(Uri.parse(apiUrl), headers: headers, body: body)
        .timeout(
      const Duration(seconds: 60),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ); // Send POST request with body
    if (response.statusCode == 200) { */
    final recipesData = {
      "recipe_name": "\n\nPlantain, Fish, and Egg Curry",
      "recipe_details":
          "\n\nThis recipe is based off of a traditional South Indian preparation. It is a moderately difficult recipe, as it requires some specific ingredients and the ability to handle various spices. \n\nIngredients:\n\n-2 ripe plantains, diced\n-4-6 fillets of white fish such as cod or halibut\n-2 teaspoons ground coriander\n-1 teaspoon ground cumin\n-1 teaspoon ground turmeric\n-1 tablespoon olive oil\n-1 large onion, diced\n-2-3 cloves garlic, minced\n-1-2 tablespoons grated ginger\n-1 teaspoon chili powder\n-1 can (14 ounces) crushed tomatoes\n-4 eggs, lightly beaten\n-1/2 cup coconut milk\n-Salt and pepper to taste\n\nInstructions:\n\n1. Heat the olive oil in a large skillet over medium heat.\n\n2. Add in the diced onion and cook until softened, about 6-7 minutes.\n\n3. Add in the minced garlic and grated ginger and cook for another minute or two.\n\n4. Add in the ground spices - coriander, cumin, turmeric, and chili powder - and stir until fragrant, about 30 seconds.\n\n5",
      "recipe_image":
          "https://oaidalleapiprodscus.blob.core.windows.net/private/org-70BO9t5kLGJujXCwMMrYBYFM/user-uRQz7odgJsEZ34w6etxnD6Mi/img-z2437MmfFYcya2OLnpih05Sm.png?st=2023-04-08T14%3A58%3A25Z&se=2023-04-08T16%3A58%3A25Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2023-04-07T21%3A36%3A41Z&ske=2023-04-08T21%3A36%3A41Z&sks=b&skv=2021-08-06&sig=URi8c49VZ4QVuuW6nZbD3%2Bnjt0kX62nhZCV0K1Ee%2BV0%3D"
    } /* json.decode(response.body) */;
    setState(() {
      _filteredRecipes = [Recipe.fromJson(recipesData)];
    });
    /*  } else {
      print('Failed to fetch recipes. Error: ${response.statusCode}');
    } */
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white,
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(
                  height: 100,
                ),
                Text(
                  "Recette pour vous",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredRecipes.length,
              itemBuilder: (context, index) => ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeDetailScreen(
                            recipe: _filteredRecipes[index],
                          )),
                ),
                title: Text(_filteredRecipes[index].label),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        'Difficulty: ${_filteredRecipes[index].difficulty ?? "easy"}'),
                    Text(
                        'Time to Cook: ${_filteredRecipes[index].timeToCook ?? "10 min"}'),
                    //Text('Description: ${_filteredRecipes[index].description}'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
