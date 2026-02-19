class Recipe {
  final int? id; // ID в нашей локальной БД (может быть null, если рецепт новый)
  final String apiId; // ID из TheMealDB
  final String name;
  final String instructions;
  final String imageUrl;
  final String category;
  final String area;

  Recipe({
    this.id,
    required this.apiId,
    required this.name,
    required this.instructions,
    required this.imageUrl,
    this.category = '',
    this.area = '',
  });

  // Создание из JSON ответа API
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      apiId: json['idMeal'] ?? '',
      name: json['strMeal'] ?? 'Без названия',
      instructions: json['strInstructions'] ?? 'Нет описания',
      imageUrl: json['strMealThumb'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
    );
  }

  // Преобразование в Map для сохранения в SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'apiId': apiId,
      'name': name,
      'instructions': instructions,
      'imageUrl': imageUrl,
      'category': category,
      'area': area,
    };
  }

  // Создание из строки базы данных
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      apiId: map['apiId'],
      name: map['name'],
      instructions: map['instructions'],
      imageUrl: map['imageUrl'],
      category: map['category'] ?? '',
      area: map['area'] ?? '',
    );
  }
}