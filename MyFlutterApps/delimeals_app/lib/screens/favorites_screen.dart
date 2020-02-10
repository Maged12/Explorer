import 'package:flutter/material.dart';
import '../models/meals.dart';
import '../widgets/meal_item.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Meal> favoriteMeals;
  FavoritesScreen(this.favoriteMeals);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  void _removeMeal(String mealId) {
    setState(() {
      widget.favoriteMeals.removeWhere((meal) => meal.id == mealId);
    });
  }
  @override
  Widget build(BuildContext context) {
    if(widget.favoriteMeals.isEmpty) {
      return Center(
        child: Text('You have no favorites yet !  < add some ;) > '),
      );
    }else{
      return  ListView.builder(
        itemBuilder: (ctx, index) {
          return MealItem(
            id: widget.favoriteMeals[index].id,
            title: widget.favoriteMeals[index].title,
            affordability: widget.favoriteMeals[index].affordability,
            complexity: widget.favoriteMeals[index].complexity,
            imageUrl: widget.favoriteMeals[index].imageUrl,
            duration: widget.favoriteMeals[index].duration,
            removeMeal: _removeMeal,
          );
        },
        itemCount: widget.favoriteMeals.length,
      );
    }
  }
}
