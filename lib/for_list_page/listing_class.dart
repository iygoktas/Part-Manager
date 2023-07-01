class Listing {
  int? id;
  String? ogrenciAdi;
  String? ogrenciSoyadi;
  String? materialAdi;
  int? materialSayisi;

  Listing(
      {this.id,
      this.ogrenciAdi,
      this.materialAdi,
      this.materialSayisi,
      this.ogrenciSoyadi});

  Listing.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    ogrenciAdi = map['ogrenciAdi'];
    ogrenciSoyadi = map['ogrenciSoyadi'];
    materialAdi = map['materialAdi'];
    materialSayisi = map['materialSayisi'];
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ogrenciAdi': ogrenciAdi,
      'ogrenciSoyadi': ogrenciSoyadi,
      'materialAdi': materialAdi,
      'materialSayisi': materialSayisi,
    };
  }
}
