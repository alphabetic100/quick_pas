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
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY,
        created_at TEXT,
        fullName TEXT,
        email TEXT,
        password TEXT,
        profileImage TEXT,
        updatedAt TEXT,
        user_id TEXT UNIQUE
      )
    ''');
    log("Local Users Database created");
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Drop and recreate the table with correct column names
      await db.execute('DROP TABLE IF EXISTS users');
      await _createDB(db, newVersion);
      log("Local Users Database upgraded to version $newVersion");
    }
  }

  Future<void> insertUser(UserData user) async {
    try {
      final db = await instance.database;
      final userData = user.toJson();
      log('Inserting user data: $userData');
      
      await db.insert(
        'users',
        userData,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      log('Successfully inserted user ${user.userId} into local database');
    } catch (error) {
      log('Error inserting user into local database: $error');
      rethrow;
    }
  }

  Future<UserData?> getUserByUserId(String userId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'user_id = ?',
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
      where: 'user_id = ?',
      whereArgs: [user.userId],
    );
  }

  Future<void> deleteUser(String userId) async {
    final db = await instance.database;
    await db.delete(
      'users',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> clearAllUsers() async {
    final db = await instance.database;
    await db.delete('users');
  }
}
