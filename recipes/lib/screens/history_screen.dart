import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final List<Map<String, String>> historyList;
  final Function(int index) onRemove;

  const HistoryScreen({
    super.key,
    required this.historyList,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (historyList.isEmpty) {
      return const Center(
        child: Text(
          'История пуста.\nНайдите что-нибудь вкусное!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: historyList.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final item = historyList[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange[100],
                  child: Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                title: Text(
                  item['name']!,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                subtitle: Text(
                  // 1. Получаем рецепт в переменную с защитой от null (если null, то пустая строка)
                  (item['recipe'] ?? '').length > 50
                  // 2. Если длина > 50, берем первые 50 символов
                      ? '${(item['recipe'] ?? '').substring(0, 50)}...'
                  // 3. Иначе выводим весь рецепт (или пустоту)
                      : (item['recipe'] ?? ''),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  tooltip: 'Удалить',
                  onPressed: () {
                    // Подтверждение перед удалением
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Удалить блюдо?'),
                        content: Text('Вы уверены, что хотите удалить "${item['name']}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Отмена'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              onRemove(index); // Вызываем удаление из родителя
                            },
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                            child: const Text('Удалить'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        if (historyList.length > 5)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              '...... (показано ${historyList.length} записей)',
              style: TextStyle(color: Colors.grey[600], letterSpacing: 2),
            ),
          ),
      ],
    );
  }
}