import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItem {
  String description;
  String category;
  String id;
  String? imageUrl;
  String name;
  num price;
  num newPrice;
  num totalOrderCount;

  MenuItem({
    required this.description,
    required this.category,
    required this.id,
    this.imageUrl,
    required this.name,
    required this.price,
    this.newPrice = 0,
    required this.totalOrderCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'category': category,
      'id': id,
      'imageUrl': imageUrl, // FIXED
      'name': name,
      'price': price,
      'newPrice': newPrice,
      'totalOrderCount': totalOrderCount, // FIXED
    };
  }

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      description: map['description'] ?? "",
      category: map['category'] ?? "",
      id: map['id'] ?? "",
      imageUrl: map['imageUrl'], // FIXED
      name: map['name'] ?? "",
      price: map['price'] ?? 0,
      newPrice: map['newPrice'] ?? 0,
      totalOrderCount: map['totalOrderCount'] ?? 0, // FIXED
    );
  }

  factory MenuItem.fromFirestore(QueryDocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;

    return MenuItem(
      id: doc.id, // ALWAYS USE FIRESTORE DOC ID
      name: map['name'] ?? "",
      category: map['category'] ?? "",
      description: map['description'] ?? "",
      imageUrl: map['imageUrl'],
      price: map['price'] ?? 0,
      newPrice: map['newPrice'] ?? 0.0,
      totalOrderCount: map['totalOrderCount'] ?? 0,
    );
  }
}
