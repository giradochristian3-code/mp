import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'item_model.dart';

// ============================================================
// ENTRY POINT - Jalankan app Pertemuan 8
// ============================================================
void main() {
  // WAJIB dipanggil sebelum akses database
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// ============================================================
// ROOT WIDGET
// ============================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Database Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage_p8(),
    );
  }
}

// ============================================================
// HOME PAGE - StatefulWidget karena data berubah-ubah
// ============================================================
class HomePage_p8 extends StatefulWidget {
  const HomePage_p8({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage_p8> {
  // Instance DatabaseHelper (Singleton)
  final dbHelper = DatabaseHelper();

  // Controller untuk TextField input
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final searchController = TextEditingController();

  // List untuk menampung data dari database
  List<Item> items = [];

  // State loading saat ambil data
  bool isLoading = true;

  // Menyimpan item yang sedang di-edit (null = mode tambah baru)
  Item? editingItem;

  // ============================================================
  // LIFECYCLE
  // ============================================================
  @override
  void initState() {
    super.initState();
    _refreshItemList(); // Muat data saat widget pertama dibuat
  }

  @override
  void dispose() {
    // Wajib dispose controller untuk mencegah memory leak
    nameController.dispose();
    descController.dispose();
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // FUNGSI DATABASE
  // ============================================================

  // Ambil semua data & perbarui UI
  Future<void> _refreshItemList() async {
    setState(() => isLoading = true);

    final List<Map<String, dynamic>> itemMaps = await dbHelper.getItems();

    setState(() {
      items = itemMaps.map((item) => Item.fromMap(item)).toList();
      isLoading = false;
    });
  }

  // Cari data berdasarkan keyword
  Future<void> _searchItems() async {
    if (searchController.text.isEmpty) {
      await _refreshItemList();
      return;
    }

    setState(() => isLoading = true);

    final List<Map<String, dynamic>> itemMaps =
        await dbHelper.searchItems(searchController.text);

    setState(() {
      items = itemMaps.map((item) => Item.fromMap(item)).toList();
      isLoading = false;
    });
  }

  // Simpan data (INSERT atau UPDATE tergantung editingItem)
  Future<void> _saveItem() async {
    // Validasi: nama tidak boleh kosong
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Nama tidak boleh kosong!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (editingItem != null) {
      // MODE UPDATE
      final updatedItem = editingItem!.copyWith(
        name: nameController.text,
        description: descController.text,
      );
      await dbHelper.updateItem(updatedItem.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Item berhasil diupdate!'),
          backgroundColor: Colors.green,
        ),
      );
      editingItem = null;
    } else {
      // MODE INSERT
      await dbHelper.insertItem({
        'name': nameController.text,
        'description': descController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Item berhasil ditambahkan!'),
          backgroundColor: Colors.green,
        ),
      );
    }

    // Bersihkan input & refresh list
    nameController.clear();
    descController.clear();
    FocusScope.of(context).unfocus();
    await _refreshItemList();
  }

  // Hapus data berdasarkan ID
  Future<void> _deleteItem(int id) async {
    await dbHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🗑️ Item berhasil dihapus!'),
        backgroundColor: Colors.red,
      ),
    );
    await _refreshItemList();
  }

  // Set data ke form untuk mode edit
  Future<void> _editItem(Item item) async {
    setState(() {
      editingItem = item;
      nameController.text = item.name;
      descController.text = item.description;
    });
  }

  // Batalkan mode edit
  void _cancelEdit() {
    setState(() {
      editingItem = null;
      nameController.clear();
      descController.clear();
    });
  }

  // ============================================================
  // UI BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Database Demo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        children: [
          // ────────────────────────────────
          // SECTION 1: FORM INPUT
          // ────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Judul form berubah sesuai mode
                    Text(
                      editingItem != null ? '✏️ Edit Item' : '➕ Tambah Item Baru',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Input Nama
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Item',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.label),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Input Deskripsi
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),

                    // Tombol Batal + Simpan/Update
                    Row(
                      children: [
                        // Tombol Batal (hanya muncul saat mode edit)
                        if (editingItem != null) ...[
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _cancelEdit,
                              icon: const Icon(Icons.cancel),
                              label: const Text('Batal'),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],

                        // Tombol Simpan / Update
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _saveItem,
                            icon: Icon(
                              editingItem != null ? Icons.save : Icons.add,
                            ),
                            label: Text(
                              editingItem != null ? 'Update' : 'Simpan',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ────────────────────────────────
          // SECTION 2: SEARCH BAR
          // ────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: '🔍 Cari Item',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    _refreshItemList(); // Reset ke semua data
                  },
                ),
              ),
              onSubmitted: (_) => _searchItems(),
            ),
          ),
          const SizedBox(height: 8),

          // Jumlah item ditemukan
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Total: ${items.length} item',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),

          // ────────────────────────────────
          // SECTION 3: LIST DATA
          // ────────────────────────────────
          Expanded(
            child: isLoading
                // Loading indicator
                ? const Center(child: CircularProgressIndicator())
                // Kalau data kosong
                : items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox,
                                size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 8),
                            Text(
                              'Belum ada data',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    // List item
                    : ListView.builder(
                        itemCount: items.length,
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            elevation: 2,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Text(
                                  '${item.id}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(item.description),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Tombol Edit
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    tooltip: 'Edit',
                                    onPressed: () => _editItem(item),
                                  ),
                                  // Tombol Hapus
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    tooltip: 'Hapus',
                                    onPressed: () => _showDeleteDialog(item),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DIALOG KONFIRMASI HAPUS
  // ============================================================
  void _showDeleteDialog(Item item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Konfirmasi Hapus'),
        content: Text('Yakin ingin menghapus item "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteItem(item.id!);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}