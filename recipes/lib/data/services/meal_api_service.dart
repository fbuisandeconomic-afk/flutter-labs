import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe_model.dart';

class MealApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // Поиск по названию
  Future<List<Recipe>> searchRecipes(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search.php?s=$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List meals = data['meals'] ?? [];

      if (meals.isEmpty) return [];

      return meals.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recipes: ${response.statusCode}');
    }
  }

  // Поиск по первой букве (опционально, для разнообразия)
  Future<List<Recipe>> searchByFirstLetter(String letter) async {
    final response = await http.get(Uri.parse('$baseUrl/search.php?f=$letter'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List meals = data['meals'] ?? [];
      return meals.map((json) => Recipe.fromJson(json)).toList();
    }
    return [];
  }
}