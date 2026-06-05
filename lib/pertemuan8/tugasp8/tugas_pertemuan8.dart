import 'package:flutter/material.dart';
import 'tugas_db_helder.dart';
import 'mahasiswa_model.dart';

class TugasP8App extends StatelessWidget {
  const TugasP8App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Database Akademik',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MahasiswaPage(),
    );
  }
}

// ===================== LIST MAHASISWA =====================
class MahasiswaPage extends StatefulWidget {
  const MahasiswaPage({super.key});

  @override
  State<MahasiswaPage> createState() => _MahasiswaPageState();
}

class _MahasiswaPageState extends State<MahasiswaPage> {
  final TugasDbHelper _db = TugasDbHelper();
  final TextEditingController _searchCtrl = TextEditingController();

  List<Mahasiswa> _list = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final maps = await _db.getMahasiswa();
    setState(() {
      _list = maps.map((m) => Mahasiswa.fromMap(m)).toList();
      _isLoading = false;
    });
  }

  Future<void> _cari(String keyword) async {
    if (keyword.isEmpty) { _loadData(); return; }
    setState(() => _isLoading = true);
    final maps = await _db.searchMahasiswa(keyword);
    setState(() {
      _list = maps.map((m) => Mahasiswa.fromMap(m)).toList();
      _isLoading = false;
    });
  }

  Future<void> _hapus(Mahasiswa mhs) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Hapus data "${mhs.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (yakin == true) {
      await _db.deleteMahasiswa(mhs.id!);
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${mhs.nama} berhasil dihapus'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _keTambah() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FormMahasiswaPage()),
    );
    _loadData();
  }

  void _keEdit(Mahasiswa mhs) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormMahasiswaPage(mahasiswaEdit: mhs)),
    );
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Database Akademik',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            color: Colors.indigo,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Text(
              '${_list.length} Mahasiswa Terdaftar',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          const SizedBox(height: 12),

          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchCtrl,
              onChanged: _cari,
              decoration: InputDecoration(
                hintText: 'Cari nama atau NIM...',
                prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () { _searchCtrl.clear(); _loadData(); },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.indigo))
                : _list.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline, size: 72, color: Colors.grey[350]),
                            const SizedBox(height: 12),
                            Text('Belum ada data mahasiswa',
                                style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                            const SizedBox(height: 6),
                            Text('Tekan tombol + untuk menambahkan',
                                style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                        itemCount: _list.length,
                        itemBuilder: (_, i) => _buildCard(_list[i]),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _keTambah,
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text(
          'Tambah',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCard(Mahasiswa mhs) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.shade100,
          child: Text(
            mhs.nama.isNotEmpty ? mhs.nama[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(mhs.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          'NIM: ${mhs.nim}\n${mhs.jurusan} — Angkatan ${mhs.angkatan}',
          style: const TextStyle(fontSize: 12),
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.indigo, size: 22),
              onPressed: () => _keEdit(mhs),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
              onPressed: () => _hapus(mhs),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================== FORM TAMBAH / EDIT =====================
class FormMahasiswaPage extends StatefulWidget {
  final Mahasiswa? mahasiswaEdit;

  const FormMahasiswaPage({super.key, this.mahasiswaEdit});

  @override
  State<FormMahasiswaPage> createState() => _FormMahasiswaPageState();
}

class _FormMahasiswaPageState extends State<FormMahasiswaPage> {
  final TugasDbHelper _db = TugasDbHelper();
  final _formKey = GlobalKey<FormState>();

  final _nimCtrl      = TextEditingController();
  final _namaCtrl     = TextEditingController();
  final _jurusanCtrl  = TextEditingController();
  final _angkatanCtrl = TextEditingController();

  bool _isSaving = false;
  bool get _isEdit => widget.mahasiswaEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final mhs = widget.mahasiswaEdit!;
      _nimCtrl.text      = mhs.nim;
      _namaCtrl.text     = mhs.nama;
      _jurusanCtrl.text  = mhs.jurusan;
      _angkatanCtrl.text = mhs.angkatan;
    }
  }

  @override
  void dispose() {
    _nimCtrl.dispose();
    _namaCtrl.dispose();
    _jurusanCtrl.dispose();
    _angkatanCtrl.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final data = Mahasiswa(
      id:       _isEdit ? widget.mahasiswaEdit!.id : null,
      nim:      _nimCtrl.text.trim(),
      nama:     _namaCtrl.text.trim(),
      jurusan:  _jurusanCtrl.text.trim(),
      angkatan: _angkatanCtrl.text.trim(),
    );

    if (_isEdit) {
      await _db.updateMahasiswa(data.toMap());
    } else {
      await _db.insertMahasiswa(data.toMap());
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEdit
              ? '✅ Data ${data.nama} berhasil diupdate!'
              : '✅ Data ${data.nama} berhasil disimpan!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          _isEdit ? 'Edit Mahasiswa' : 'Tambah Mahasiswa',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person_pin, color: Colors.white70, size: 36),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isEdit ? 'Form Edit Mahasiswa' : 'Form Pendaftaran',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          _isEdit ? 'Ubah data yang perlu diperbarui' : 'Isi semua data dengan benar',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              _field(
                controller: _nimCtrl,
                label: 'NIM *',
                icon: Icons.badge_outlined,
                hint: 'Contoh: 241011701367',
                inputType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'NIM wajib diisi';
                  if (v.trim().length < 6) return 'NIM minimal 6 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              _field(
                controller: _namaCtrl,
                label: 'Nama Lengkap *',
                icon: Icons.person_outline,
                hint: 'Contoh: Budi Santoso',
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Nama wajib diisi';
                  if (v.trim().length < 3) return 'Nama minimal 3 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              _field(
                controller: _jurusanCtrl,
                label: 'Program Studi / Jurusan *',
                icon: Icons.school_outlined,
                hint: 'Contoh: Sistem Informasi',
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Jurusan wajib diisi';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              _field(
                controller: _angkatanCtrl,
                label: 'Tahun Angkatan *',
                icon: Icons.calendar_today_outlined,
                hint: 'Contoh: 2024',
                inputType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Angkatan wajib diisi';
                  if (v.trim().length != 4) return 'Format tahun: 4 digit (contoh: 2024)';
                  return null;
                },
              ),
              const SizedBox(height: 28),

              // Tombol Simpan
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _simpan,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Icon(_isEdit ? Icons.save : Icons.check_circle),
                  label: Text(
                    _isSaving ? 'Menyimpan...' : _isEdit ? 'Update Data' : 'Simpan Data',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Tombol Batal
              SizedBox(
                height: 46,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Batal / Kembali'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.indigo,
                    side: const BorderSide(color: Colors.indigo),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    required String? Function(String?) validator,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.indigo),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.indigo, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}