import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:quick_pass/src/app/features/profile/data/user_data.dart';

class LocalUserService {
  static final LocalUserService instance = LocalUserService._internal();
  Database? _database;

  factory LocalUserService() {
    return instance;
  }

  LocalUserService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'quick_pass_users.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY,
        createdAt TEXT,
        fullName TEXT,
        email TEXT,
        password TEXT,
        profileImage TEXT,
        updatedAt TEXT,
        userId TEXT UNIQUE
      )
    ''');
    log("Local Users Database created");
  }

  Future<void> insertUser(UserData user) async {
    final db = await instance.database;
    await db.insert(
      'users',
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserData?> getUserByUserId(String userId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return UserData.fromJson(maps.first);
    }
    return null;
  }

  Future<void> updateUser(UserData user) async {
    final db = await instance.database;
    await db.update(
      'users',
      user.toJson(),
      where: 'userId = ?',
      whereArgs: [user.userId],
    );
  }

  Future<void> deleteUser(String userId) async {
    final db = await instance.database;
    await db.delete(
      'users',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future<void> clearAllUsers() async {
    final db = await instance.database;
    await db.delete('users');
  }
}
