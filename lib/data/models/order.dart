import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String userId;
  final String id;
  final num orderId;
  final List<Map<String, dynamic>> items;
  String address;
  double totalPrice;
  String orderState; // pending, preparing, onTheWay, completed, cancelled
  final DateTime createdAt;

  OrderItem({
    required this.userId,
    required this.id,
    required this.orderId,
    required this.items,
    required this.totalPrice,
    required this.orderState,
    required this.address,
    required this.createdAt,
  });

  factory OrderItem.fromMap(Map<String, dynamic> data) {
    return OrderItem(
      userId: (data['userId']).toString(),
      id: (data['id'] ?? '').toString(),
      orderId: (data['orderId']),
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      orderState: (data['orderState'] ?? 'pending').toString(),
      address: (data['address'] ?? '').toString(),
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),

      items: (data["items"] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'orderId': orderId,
      'items': items,
      'totalPrice': totalPrice,
      'orderState': orderState,
      'address': address,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
