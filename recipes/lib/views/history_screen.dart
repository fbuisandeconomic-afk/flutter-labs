import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../view_models/recipe_view_model.dart';
import 'recipe_detail_screen.dart'; // Импорт экрана деталей

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RecipeViewModel>();

    // Заголовок экрана
    return Scaffold(
      appBar: AppBar(
        title: const Text('История запросов'),
        centerTitle: true,
      ),
      body: viewModel.isLoading && viewModel.history.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : viewModel.history.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_toggle_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text("История пуста.\nНайдите что-нибудь вкусное!", textAlign: TextAlign.center),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: viewModel.history.length,
        itemBuilder: (context, index) {
          final recipe = viewModel.history[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: recipe.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                  imageUrl: recipe.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                )
                    : Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.restaurant),
                ),
              ),
              title: Text(
                recipe.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                "${recipe.category} • ${recipe.area}",
                style: const TextStyle(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              isThreeLine: false,
              // Переход к деталям при клике на строку
              onTap: () {
                if (recipe.id != null) { // Проверка на всякий случай
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecipeDetailScreen(recipe: recipe)),
                  );
                }
              },
              // Явная кнопка удаления
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                tooltip: 'Удалить из истории',
                onPressed: () {
                  if (recipe.id != null) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Удалить блюдо?'),
                        content: Text('Вы уверены, что хотите удалить "${recipe.name}" из истории?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              viewModel.removeFromHistory(recipe.id!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${recipe.name} удален')),
                              );
                            },
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                            child: const Text('Удалить'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}