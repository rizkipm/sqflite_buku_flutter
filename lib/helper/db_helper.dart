import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_buku_flutter/model/model_buku.dart';

class DatabaseHelper{

  static final DatabaseHelper instance = DatabaseHelper._instance();

  static Database? _database;
  DatabaseHelper._instance();

  Future<Database> get db async{
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async{
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'db_buku');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  //proses untuk buat table
  Future _onCreate(Database db, int version) async{
    await db.execute('''
      CREATE TABLE tb_buku (
      id INTEGER PRIMARY KEY,
      judulbuku TEXT,
      kategori TEXT
    )
    ''');
  }

  Future<int> insertBuku(ModelBuku buku) async{
    Database db = await instance.db;
    return await db.insert('tb_buku', buku.toMap());
  }

  Future<List<Map<String, dynamic>>> quaryAllBuku() async{
    Database db = await instance.db;
    return await db.query('tb_buku');
  }

  Future<int> updateBuku(ModelBuku buku) async{
    Database db = await instance.db;
    return await db.update('tb_buku', buku.toMap(), where: 'id = ?', whereArgs: [buku.id]);
  }

  Future<int> deleteUser(int id) async{
    Database db = await instance.db;
    return await db.delete('tb_buku', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> dummyBuku() async{
    List<ModelBuku> dataBukuToAdd = [
      ModelBuku(judulbuku: "Hii Miko", kategori: 'Komik'),
      ModelBuku(judulbuku: "Scrambled 1", kategori: 'Komik'),
      ModelBuku(judulbuku: "Raden Ajeng Kartini", kategori: 'Novel'),
      ModelBuku(judulbuku: "Untukmu anak bungsu", kategori: 'Psikolog'),
      ModelBuku(judulbuku: "Hidup ini terlalu banyak kamu", kategori: 'Novel'),

    ];
    for (ModelBuku modelBuku in dataBukuToAdd){
      await insertBuku(modelBuku);
    }
  }
}