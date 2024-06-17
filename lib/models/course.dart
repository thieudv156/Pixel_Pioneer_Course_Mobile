import 'dart:developer';

class Course {
  final int id;
  final String title;
  final String instructorName;
  final String imageUrl;
  final double price;

  Course({
    required this.id,
    required this.title,
    required this.instructorName,
    required this.imageUrl,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'instructorName': instructorName,
      'imageUrl': imageUrl,
      'price': price,
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    log(json.toString());
    return Course(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown Title',
      instructorName: json['instructorName'] ??
          'Anonymous', // Access nested instructor name
      imageUrl: json['imageUrl'] ??
          'https://th.bing.com/th/id/R.26ff8f39241b3a8a90817f04f86d2214?rik=7UPym3r1dnBKIA&pid=ImgRaw&r=0',
      price: (json['price'] ?? 0.0).toDouble(),
    );
  }
}
