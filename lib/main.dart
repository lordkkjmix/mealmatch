import 'package:flutter/material.dart';

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
  final List<String> _ingredients = [
    'Eggs',
    'Milk',
    'Cheese',
    'Tomatoes',
    'Onions',
    'Potatoes'
  ];
  late List<bool> _selectedIngredients;

  @override
  void initState() {
    super.initState();
    _selectedIngredients = List.generate(_ingredients.length, (index) => false);
  }

  void _toggleIngredient(int index) {
    setState(() {
      _selectedIngredients[index] = !_selectedIngredients[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MealMash - Select Ingredients'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: GridView.builder(
              shrinkWrap: true,
              itemCount: _ingredients.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                return FilterChip(
                  label: Text(_ingredients[index]),
                  selected: _selectedIngredients[index],
                  onSelected: (bool selected) {
                    _toggleIngredient(index);
                  },
                );
              },
            )),
            ElevatedButton(
              onPressed: () {
                print(
                    'Selected Ingredients: ${_selectedIngredients.asMap().entries.where((entry) => entry.value).map((entry) => _ingredients[entry.key]).toList()}');
              },
              child: const Text('Find Recipes'),
            ),
          ],
        ),
      ),
    );
  }
}
