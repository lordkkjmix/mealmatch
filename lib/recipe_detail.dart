import 'package:flutter/material.dart';
import 'package:mealmatch/main.dart';
import 'package:mealmatch/recipes_list_screen.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(recipe.image),
              Text(
                recipe.label,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Text('Difficulty: ${recipe.difficulty ?? ""}'),
              SizedBox(height: 8.0),
              Text('Time to Cook: ${recipe.timeToCook ?? ""}'),
              SizedBox(height: 8.0),
              Text('Description: ${recipe.description}'),
            ],
          ),
        ),
      ),
    );
  }
}
