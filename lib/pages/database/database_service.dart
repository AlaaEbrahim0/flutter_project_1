import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:world_time_app/pages/models/student.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get db async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> deleteDatabase() async {
    final path = await fullPath;
    return databaseFactory.deleteDatabase(path);
  }

  Future<Database> _initDatabase() async {
    final path = await fullPath;
    var database = await openDatabase(path,
        version: 1, onCreate: create, singleInstance: true);
    return database;
  }

  Future<void> create(Database database, int version) async {
    await StudentDb().createTable(database);
  }

  Future<String> get fullPath async {
    const name = 'student.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }
}

class StudentDb {
  final tableName = 'students';
  Future<void> createTable(Database database) async {
    await database.execute('''
    CREATE TABLE IF NOT EXISTS $tableName (
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      gender TEXT DEFAULT 'male' CHECK (gender IN ('male', 'female')),
      email TEXT UNIQUE NOT NULL,
      level INTEGER DEFAULT 1 CHECK (level >= 1 AND level <= 4),
      password TEXT NOT NULL CHECK (LENGTH(password) >= 8),
      image TEXT DEFAULT NULL
    )
  ''');
  }

  Future<int> create(
      {required String name,
      required String email,
      required int level,
      required String password,
      String? gender,
      String? image}) async {
    final db = await DatabaseService().db;
    return await db.rawInsert(
      'INSERT INTO $tableName (name, email, level, password, gender, image) VALUES (?, ?, ?, ?, ?, ?)',
      [name, email, level, password, gender],
    );
  }

  Future<Student> fetchById(int id) async {
    final db = await DatabaseService().db;
    final student =
        await db.rawQuery('''SELECT * FROM $tableName WHERE id = ?''', [id]);
    return Student.fromJson(student.first);
  }

  Future<Student> fetchByEmail(String email) async {
    debugger();
    final db = await DatabaseService().db;
    final student = await db
        .rawQuery('''SELECT * FROM $tableName WHERE email = ?''', [email]);
    return Student.fromJson(student.first);
  }

  Future<int> update(
      {required String name,
      required String email,
      required int level,
      required String password,
      String? gender,
      String? image}) async {
    final db = await DatabaseService().db;
    return await db.rawUpdate(
      'UPDATE $tableName SET name = ?, level = ?, password = ?, gender = ?, image = ? WHERE email = ?',
      [name, level, password, gender, image, email],
    );
  }
}
