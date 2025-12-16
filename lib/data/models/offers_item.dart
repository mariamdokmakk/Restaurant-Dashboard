import 'package:cloud_firestore/cloud_firestore.dart';

class OffersItem {
  String id;
  String title;
  String category;
  num discountPercent;
  bool isActive;
  DateTime validFrom;
  DateTime validTo;

  OffersItem({
    required this.id,
    required this.title,
    required this.category,
    required this.discountPercent,
    required this.isActive,
    required this.validFrom,
    required this.validTo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'discountPercent': discountPercent,
      'isActive': isActive,
      'validFrom': Timestamp.fromDate(validFrom),
      'validTo': Timestamp.fromDate(validTo),
    };
  }

  factory OffersItem.fromMap(Map<String, dynamic> map) {
    return OffersItem(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      discountPercent: map['discountPercent'] ?? 0,
      isActive: map['isActive'] ?? false,
      validFrom: (map['validFrom'] as Timestamp).toDate(),
      validTo: (map['validTo'] as Timestamp).toDate(),
    );
  }
}
