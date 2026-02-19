import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/history_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'МИР - РЕЦЕПТОВ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const MainScreen(), // Главный экран с навигацией
    );
  }
}

// Виджет-обертка, управляющий нижней навигацией и общим состоянием
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Общий список истории (Бизнес-логика: хранение состояния)
  // Изначально добавим пару тестовых блюд
  final List<Map<String, String>> _historyList = [
    {'name': 'Блюдо 1', 'recipe': 'Рецепт блюда 1...'},
    {'name': 'Блюдо 2', 'recipe': 'Рецепт блюда 2...'},
    {'name': 'Блюдо 3', 'recipe': 'Рецепт блюда 3...'},
    {'name': 'Блюдо 4', 'recipe': 'Рецепт блюда 4...'},
    {'name': 'Блюдо 5', 'recipe': 'Рецепт блюда 5...'},
  ];

  // Метод для добавления блюда в историю (вызывается с Главного экрана)
  void addToHistory(String name, String recipe) {
    setState(() {
      // Добавляем новое блюдо в начало списка
      _historyList.insert(0, {'name': name, 'recipe': recipe});
    });
    // Переключаемся на вкладку истории, чтобы пользователь увидел результат
    setState(() {
      _currentIndex = 1;
    });
  }

  // Метод для удаления блюда (вызывается с экрана Истории)
  void removeFromHistory(int index) {
    setState(() {
      _historyList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Экран поиска: передаем функцию добавления и текущий текст
          HomeScreen(onRecipeFound: addToHistory),
          // Экран истории: передаем список и функцию удаления
          HistoryScreen(
            historyList: _historyList,
            onRemove: removeFromHistory,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'История',
          ),
        ],
      ),
    );
  }
}