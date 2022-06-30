
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:test_kairos/model/model.dart';

class DatabaseProduct {
  static final DatabaseProduct instance = DatabaseProduct._init();

  static Database? _database;

  DatabaseProduct._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');

    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';

    final textType = 'TEXT NOT NULL';
    final intType = 'INTEGER NOT NULL';

    await db.execute('''CREATE TABLE  $tableData (
      ${ResultField.id} $idType,
      ${ResultField.namabarang} $textType,
      ${ResultField.kodebarang} $textType,
      ${ResultField.jumlahbarang} $intType,
      ${ResultField.datetime} $textType
     
    )''');
  }

  Future<ProductModel> create(ProductModel note) async {
    final db = await instance.database;

    // final json = note.toJson();
    // final columns='${NoteField.title},${NoteField.description},${NoteField.time}';
    // final values='${json[NoteField.title]},${json[NoteField.description]},${json[NoteField.time]}';
    // final id=await db.rawInsert('INSERT INTO table_name ');
    final id = await db.insert(tableData, note.toJson());

    return note.copy(id: id);
  }

  // Future<Note> readNote(int id) async {
  //   final db = await instance.database;

  //   final maps = await db.query(tableData,
  //       columns: ResultField.values,
  //       where: '${ResultField.id}=?',
  //       whereArgs: [id]);
  //   if (maps.isNotEmpty) {
  //     return Note.fromJson(maps.first);
  //   } else {
  //     throw Exception(' $id not found');
  //   }
  // }

  Future<List<ProductModel>> readAllNotes() async {
    final db = await instance.database;

    // final orderBy = '${ResultField.time} ASC';

    final result = await db.query(tableData);
    print('woy $result');

    // List<String> comments = ["1st", "2nd", "3rd"];
    // Map<String, dynamic> args = {"comments": comments};
    // String url = "myurl.com";
    // var body = json.encode(args);
    // print(body);

    return result.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<List<ProductModel>> searchProduct({String? namabarang, String? kodebarang}) async {
    final db = await instance.database;

    

    final result = await db.rawQuery(
        "SELECT * FROM data WHERE namabarang LIKE '%${namabarang}%' OR  kodebarang LIKE '%${kodebarang}%'");

    
    print('apasih $result');

    return result.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<bool> update(ProductModel resultOffline) async {
    final db = await instance.database;
    print('woooo ${resultOffline}');

    db.update(tableData, resultOffline.toJson(),
        where: '${ResultField.id}= ?', whereArgs: [resultOffline.id]);
        print('success update');

    return Future.value(true);
  }

  Future delete(int id) async {
    final db = await instance.database;
    await db.delete(tableData, where: '${ResultField.id} = ?', whereArgs: [id]);
    return Future.value(true);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
