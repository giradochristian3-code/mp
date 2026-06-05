// ============================================================
// MODEL DATA ITEM
// Representasi objek dari baris data di tabel 'items'
// ============================================================
class Item {
  int? id;           // nullable karena saat INSERT belum punya ID
  String name;
  String description;

  // Constructor
  Item({
    this.id,
    required this.name,
    required this.description,
  });

  // Konversi objek Item → Map (untuk disimpan ke database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  // Factory constructor: buat objek Item dari Map (hasil query database)
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }

  // copyWith: buat salinan objek Item dengan beberapa field diubah
  // Berguna saat UPDATE — tidak perlu buat objek baru dari scratch
  Item copyWith({
    int? id,
    String? name,
    String? description,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  // Untuk debugging — print objek Item
  @override
  String toString() {
    return 'Item{id: $id, name: $name, description: $description}';
  }
}