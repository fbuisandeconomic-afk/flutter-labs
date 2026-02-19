import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Пример данных (в будущем будут браться из базы)
    final List<String> dishes = [
      'Блюдо 1',
      'Блюдо 2',
      'Блюдо 3',
      'Блюдо 4',
      'Блюдо 5',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'МИР - РЕЦЕПТОВ',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: dishes.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    dishes[index],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      // Логика удаления будет здесь
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${dishes[index]} удалено')),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text('......', style: TextStyle(fontSize: 20, letterSpacing: 4)),
          ),
        ],
      ),
      // Нижняя навигация
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}