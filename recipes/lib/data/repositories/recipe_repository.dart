import '../models/recipe_model.dart';
import '../services/meal_api_service.dart';
import '../local/database_helper.dart';

class RecipeRepository {
  final MealApiService _apiService = MealApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Поиск в API
  Future<List<Recipe>> searchRecipes(String query) async {
    try {
      return await _apiService.searchRecipes(query);
    } catch (e) {
      print("API Error: $e");
      return []; // Возвращаем пустой список при ошибке сети
    }
  }

  // Сохранение в локальную БД
  Future<int> saveRecipe(Recipe recipe) async {
    return await _dbHelper.insertRecipe(recipe);
  }

  // Получение истории из БД
  Future<List<Recipe>> getHistory() async {
    return await _dbHelper.getAllRecipes();
  }

  // Удаление из БД
  Future<void> removeRecipe(int id) async {
    await _dbHelper.deleteRecipe(id);
  }
}