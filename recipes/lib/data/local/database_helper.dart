import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/recipe_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('recipes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textTypeNullable = 'TEXT';

    await db.execute('''
      CREATE TABLE recipes (
        id $idType,
        apiId $textType,
        name $textType,
        instructions $textType,
        imageUrl $textType,
        category $textTypeNullable,
        area $textTypeNullable
      )
    ''');
  }

  // Добавить рецепт
  Future<int> insertRecipe(Recipe recipe) async {
    final db = await database;
    // Проверяем, нет ли уже такого рецепта по apiId
    final existing = await db.query('recipes', where: 'apiId = ?', whereArgs: [recipe.apiId]);
    if (existing.isNotEmpty) {
      return existing.first['id'] as int; // Возвращаем ID существующего
    }
    return await db.insert('recipes', recipe.toMap());
  }

  // Получить все рецепты
  Future<List<Recipe>> getAllRecipes() async {
    final db = await database;
    final maps = await db.query('recipes', orderBy: 'id DESC');
    return maps.map((map) => Recipe.fromMap(map)).toList();
  }

  // Удалить рецепт
  Future<int> deleteRecipe(int id) async {
    final db = await database;
    return await db.delete('recipes', where: 'id = ?', whereArgs: [id]);
  }

  // Очистить базу (для тестов)
  Future<void> clearAll() async {
    final db = await database;
    await db.delete('recipes');
  }
}