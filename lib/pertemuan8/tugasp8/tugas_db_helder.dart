import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TugasDbHelper {
  static final TugasDbHelper _instance = TugasDbHelper._internal();
  static Database? _database;

  factory TugasDbHelper() => _instance;
  TugasDbHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'akademik.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE mahasiswa(
        id        INTEGER PRIMARY KEY AUTOINCREMENT,
        nim       TEXT NOT NULL,
        nama      TEXT NOT NULL,
        jurusan   TEXT NOT NULL,
        angkatan  TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertMahasiswa(Map<String, dynamic> data) async {
    Database db = await database;
    return await db.insert('mahasiswa', data);
  }

  Future<List<Map<String, dynamic>>> getMahasiswa() async {
    Database db = await database;
    return await db.query('mahasiswa', orderBy: 'nama ASC');
  }

  Future<List<Map<String, dynamic>>> searchMahasiswa(String keyword) async {
    Database db = await database;
    return await db.query(
      'mahasiswa',
      where: 'nama LIKE ? OR nim LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
    );
  }

  Future<int> updateMahasiswa(Map<String, dynamic> data) async {
    Database db = await database;
    return await db.update(
      'mahasiswa',
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
  }

  Future<int> deleteMahasiswa(int id) async {
    Database db = await database;
    return await db.delete(
      'mahasiswa',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}