class Ogrenci {
  int? id;
  String? ad;
  String? soyad;
  String? numara;
  String? sinif;
  String? sube;

  Ogrenci(
      {required this.ad,
      required this.soyad,
      required this.numara,
      required this.sinif,
      required this.sube});

  Ogrenci.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    ad = map['ad'];
    soyad = map['soyad'];
    numara = map['numara'];
    sinif = map['sinif'];
    sube = map['sube'];
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ad': ad,
      'soyad': soyad,
      'numara': numara,
      'sinif': sinif,
      'sube': sube,
    };
  }
}
