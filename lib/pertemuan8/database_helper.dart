import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // ============================================================
  // SINGLETON PATTERN
  // Memastikan hanya ada SATU instance DatabaseHelper di seluruh app
  // ============================================================
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Factory constructor - setiap kali dipanggil, kembalikan instance yang SAMA
  factory DatabaseHelper() => _instance;

  // Constructor privat - hanya bisa dipanggil dari dalam kelas ini
  DatabaseHelper._internal();

  // ============================================================
  // GETTER DATABASE
  // Kalau database belum ada → buat baru
  // Kalau sudah ada → kembalikan yang sudah ada
  // ============================================================
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // ============================================================
  // INISIALISASI DATABASE
  // Membuat/membuka file database di storage perangkat
  // ============================================================
  Future<Database> _initDatabase() async {
    // getDatabasesPath() → dapat lokasi folder database di HP/emulator
    // join() → gabungkan path + nama file
    String path = join(await getDatabasesPath(), 'pertemuan8.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb, // dipanggil HANYA saat database pertama kali dibuat
    );
  }

  // ============================================================
  // BUAT STRUKTUR TABEL
  // Dipanggil otomatis saat database baru dibuat (onCreate)
  // ============================================================
  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT
      )
    ''');
  }

  // ============================================================
  // OPERASI CRUD
  // ============================================================

  // CREATE - Tambah data baru ke tabel
  Future<int> insertItem(Map<String, dynamic> item) async {
    Database db = await database;
    return await db.insert('items', item);
  }

  // READ - Ambil semua data dari tabel
  Future<List<Map<String, dynamic>>> getItems() async {
    Database db = await database;
    return await db.query('items');
  }

  // READ - Cari data berdasarkan keyword (LIKE query)
  Future<List<Map<String, dynamic>>> searchItems(String keyword) async {
    Database db = await database;
    return await db.query(
      'items',
      where: 'name LIKE ? OR description LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
    );
  }

  // UPDATE - Perbarui data berdasarkan ID
  Future<int> updateItem(Map<String, dynamic> item) async {
    Database db = await database;
    return await db.update(
      'items',
      item,
      where: 'id = ?',
      whereArgs: [item['id']], // whereArgs mencegah SQL injection
    );
  }

  // DELETE - Hapus data berdasarkan ID
  Future<int> deleteItem(int id) async {
    Database db = await database;
    return await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}