import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  // Callback функция, которую нам передаст родитель (MainScreen)
  final Function(String name, String recipe) onRecipeFound;

  const HomeScreen({super.key, required this.onRecipeFound});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Переменные для отображения результата
  String? _resultName;
  String? _resultRecipe;
  bool _isLoading = false;

  void _performSearch() {
    if (_searchController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _resultName = null;
      _resultRecipe = null;
    });

    // Имитация задержки сети (бизнес-логика поиска)
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      final query = _searchController.text;

      setState(() {
        _isLoading = false;
        // Формируем фейковый рецепт на основе ввода
        _resultName = query.toUpperCase();
        _resultRecipe = 'Это отличный рецепт для блюда "$query".\n\n'
            'Ингредиенты:\n- 100г любви\n- 200г старания\n- Щепотка специй.\n\n'
            'Приготовление:\n1. Смешать ингредиенты.\n2. Готовить с удовольствием.';
      });
    });
  }

  void _addToHistory() {
    if (_resultName != null && _resultRecipe != null) {
      widget.onRecipeFound(_resultName!, _resultRecipe!);

      // Показываем уведомление
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Блюдо "${_resultName}" добавлено в историю!'),
          backgroundColor: Colors.green,
        ),
      );

      // Очищаем поле и результат
      _searchController.clear();
      setState(() {
        _resultName = null;
        _resultRecipe = null;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          // Поле ввода
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Введите блюдо для поиска',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            onSubmitted: (_) => _performSearch(), // Поиск по Enter
          ),
          const SizedBox(height: 16),

          // Кнопка поиска
          ElevatedButton(
            onPressed: _isLoading ? null : _performSearch,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('НАЙТИ РЕЦЕПТ', style: TextStyle(fontSize: 16)),
          ),

          const SizedBox(height: 24),

          // Область результатов
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _resultName == null
                ? const Center(
              child: Text(
                'Введите название блюда выше,\nчтобы найти рецепт.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            )
                : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _resultName!,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const Divider(),
                          Text(
                            _resultRecipe!,
                            style: const TextStyle(fontSize: 16, height: 1.5),
                          ),
                          const SizedBox(height: 20),
                          // Кнопка "Добавить в историю" прямо в карточке
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _addToHistory,
                              icon: const Icon(Icons.add_circle_outline),
                              label: const Text('Сохранить в историю'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}