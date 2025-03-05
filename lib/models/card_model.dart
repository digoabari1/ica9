class CardModel {
  final int? id;
  final String name;
  final String suit;
  final String imageUrl;
  final int folderId;

  CardModel({this.id, required this.name, required this.suit, required this.imageUrl, required this.folderId});

  factory CardModel.fromMap(Map<String, dynamic> json) => CardModel(
    id: json['id'],
    name: json['name'],
    suit: json['suit'],
    imageUrl: json['image_url'],
    folderId: json['folder_id'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'suit': suit,
    'image_url': imageUrl,
    'folder_id': folderId,
  };
}
