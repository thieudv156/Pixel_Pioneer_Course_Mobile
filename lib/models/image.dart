class Image {
  final int id;
  final String imageName;
  final String imageType;
  final String imageUrl;

  Image({
    required this.id,
    required this.imageName,
    required this.imageType,
    required this.imageUrl,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json['id'] ?? 0,
      imageName: json['imageName'] ?? '',
      imageType: json['imageType'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageName': imageName,
      'imageType': imageType,
      'imageUrl': imageUrl,
    };
  }
}
