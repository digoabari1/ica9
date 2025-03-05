class Folder {
  final int? id;
  final String name;

  Folder({this.id, required this.name});

  factory Folder.fromMap(Map<String, dynamic> json) => Folder(
    id: json['id'],
    name: json['name'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
  };
}
