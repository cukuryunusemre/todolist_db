import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'personel_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS Personel(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ad TEXT,
            soyad TEXT,
            departman TEXT,
            maas INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertPersonel(Map<String, dynamic> personel) async {
    final db = await database;
    await db.insert('Personel', personel);
  }

  Future<void> updatePersonel(int id, Map<String, dynamic> updatedValues) async {
    final db = await database;
    await db.update(
      'Personel',
      updatedValues,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deletePersonel(int id) async {
    final db = await database;
    await db.delete(
      'Personel',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getPersonelGroupedByDepartment() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT departman, COUNT(*) AS personel_sayisi, AVG(maas) AS ortalama_maas
      FROM Personel
      GROUP BY departman
    ''');
  }

  Future<List<Map<String, dynamic>>> getAllPersonel() async {
    final db = await database;
    return await db.query('Personel');
  }

}
