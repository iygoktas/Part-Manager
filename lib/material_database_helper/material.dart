class Materials {
  int? id;
  String? name;

  Materials({required this.name});

  Materials.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
