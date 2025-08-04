import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:quick_pass/src/app/features/home/data/home_pass_data_mode.dart';

class LocalDatabaseService {
  static final LocalDatabaseService instance = LocalDatabaseService._internal();
  Database? _database;

  factory LocalDatabaseService() {
    return instance;
  }

  LocalDatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'quick_pass.db');

    return await openDatabase(
      path,
      version: 2, // Updated version to trigger migration
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE passwords(
        id INTEGER PRIMARY KEY,
        passId TEXT,
        createdAt TEXT,
        updatedAt TEXT,
        userId TEXT,
        name TEXT,
        url TEXT,
        password TEXT,
        email TEXT,
        encrypted_password TEXT,
        encrypted_email TEXT,
        UNIQUE(id, userId)
      )
    ''');
    log("Local Database created with encryption support");
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    log("Upgrading database from version $oldVersion to $newVersion");
    
    if (oldVersion < 2) {
      // Add encrypted columns if they don't exist
      try {
        await db.execute('ALTER TABLE passwords ADD COLUMN encrypted_password TEXT');
        await db.execute('ALTER TABLE passwords ADD COLUMN encrypted_email TEXT');
        log("Added encrypted columns to existing database");
      } catch (e) {
        // Columns might already exist, log and continue
        log("Encrypted columns may already exist: $e");
      }
    }
  }

  Future<void> insertPassword(PasswordModel password) async {
    final db = await instance.database;
    await db.insert(
      'passwords',
      password.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PasswordModel>> fetchAllPasswords() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('passwords');
    return List.generate(maps.length, (i) {
      return PasswordModel.fromJson({
        'id': maps[i]['id'],
        'pass_id': maps[i]['passId'],
        'created_at': maps[i]['createdAt'],
        'updated_at': maps[i]['updatedAt'],
        'user_id': maps[i]['userId'],
        'name': maps[i]['name'],
        'url': maps[i]['url'],
        'password': maps[i]['password'],
        'email': maps[i]['email'],
        'encrypted_password': maps[i]['encrypted_password'],
        'encrypted_email': maps[i]['encrypted_email'],
      });
    });
  }

  Future<List<PasswordModel>> fetchPasswordsForUser(String userId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'passwords',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return PasswordModel.fromJson({
        'id': maps[i]['id'],
        'pass_id': maps[i]['passId'],
        'created_at': maps[i]['createdAt'],
        'updated_at': maps[i]['updatedAt'],
        'user_id': maps[i]['userId'],
        'name': maps[i]['name'],
        'url': maps[i]['url'],
        'password': maps[i]['password'],
        'email': maps[i]['email'],
        'encrypted_password': maps[i]['encrypted_password'],
        'encrypted_email': maps[i]['encrypted_email'],
      });
    });
  }

  Future<void> clearPasswords() async {
    final db = await instance.database;
    await db.delete('passwords');
  }

  Future<void> clearPasswordsForUser(String userId) async {
    final db = await instance.database;
    await db.delete('passwords', where: 'userId = ?', whereArgs: [userId]);
  }
}
