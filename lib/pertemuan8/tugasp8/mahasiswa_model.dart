class Mahasiswa {
  int? id;
  String nim;
  String nama;
  String jurusan;
  String angkatan;

  Mahasiswa({
    this.id,
    required this.nim,
    required this.nama,
    required this.jurusan,
    required this.angkatan,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nim': nim,
      'nama': nama,
      'jurusan': jurusan,
      'angkatan': angkatan,
    };
  }

  factory Mahasiswa.fromMap(Map<String, dynamic> map) {
    return Mahasiswa(
      id: map['id'],
      nim: map['nim'],
      nama: map['nama'],
      jurusan: map['jurusan'],
      angkatan: map['angkatan'],
    );
  }

  Mahasiswa copyWith({
    int? id,
    String? nim,
    String? nama,
    String? jurusan,
    String? angkatan,
  }) {
    return Mahasiswa(
      id: id ?? this.id,
      nim: nim ?? this.nim,
      nama: nama ?? this.nama,
      jurusan: jurusan ?? this.jurusan,
      angkatan: angkatan ?? this.angkatan,
    );
  }
}