import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:rest_dashboard/data/models/menu_item.dart';

class MenuService {
  static final _db = FirebaseFirestore.instance;
  static const String _restaurantCollection = "Restaurant";
  static const String _restaurantId = "UFrCk69XBDrXFMOCuMvB";

  static Future<void> addMenuItem({
    required String name,
    required String description,
    required String category,
    required num price,
    String? imageUrl,
  }) async {
    final existing = await _db
        .collection(_restaurantCollection)
        .doc(_restaurantId)
        .collection("menu")
        .where("name", isEqualTo: name.trim())
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      throw Exception("Item with this name already exists");
    }

    final docRef = _db
        .collection(_restaurantCollection)
        .doc(_restaurantId)
        .collection("menu")
        .doc();

    final item = MenuItem(
      id: docRef.id,
      name: name,
      description: description,
      category: category,
      price: price,
      imageUrl: imageUrl,
      totalOrderCount: 0,
      // quantity: 0,
    );

    await docRef.set(item.toMap());
  }

  /// GET ALL MENU ITEMS
  static Stream<List<MenuItem>> getMenuItems() {
    return _db
        .collection(_restaurantCollection)
        .doc(_restaurantId)
        .collection("menu")
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => MenuItem.fromMap(doc.data())).toList(),
        );
  }

  static Future<void> deleteMenuItem(String id) {
    return _db
        .collection(_restaurantCollection)
        .doc(_restaurantId)
        .collection("menu")
        .doc(id)
        .delete();
  }
}
