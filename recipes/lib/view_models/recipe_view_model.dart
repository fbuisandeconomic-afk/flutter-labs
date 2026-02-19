import 'package:flutter/foundation.dart';
import '../data/models/recipe_model.dart';
import '../data/repositories/recipe_repository.dart';

class RecipeViewModel extends ChangeNotifier {
  final RecipeRepository _repository = RecipeRepository();

  List<Recipe> _searchResults = [];
  List<Recipe> _history = [];
  bool _isLoading = false;
  String? _error;

  // Геттеры для доступа из UI
  List<Recipe> get searchResults => _searchResults;
  List<Recipe> get history => _history;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Инициализация (загрузка истории при старте)
  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();

    _history = await _repository.getHistory();

    _isLoading = false;
    notifyListeners();
  }

  // Поиск рецепта
  Future<void> searchRecipes(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _searchResults = await _repository.searchRecipes(query);
      if (_searchResults.isEmpty) {
        _error = "Ничего не найдено по запросу '$query'";
      }
    } catch (e) {
      _error = "Ошибка сети: $e";
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Сохранение в историю
  Future<void> addToHistory(Recipe recipe) async {
    await _repository.saveRecipe(recipe);
    // Обновляем локальный список истории
    await loadHistory();
  }

  // Удаление из истории
  Future<void> removeFromHistory(int id) async {
    await _repository.removeRecipe(id);
    // Обновляем локальный список
    _history.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}