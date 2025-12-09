import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:rest_dashboard/data/models/menu_item.dart';

class MenuService {
  static final _db = FirebaseFirestore.instance;
  static const String _restaurantCollection = "Restaurant";
  static const String _restaurantId = "UFrCk69XBDrXFMOCuMvB";
  // static final cloudinary = CloudinaryPublic(
  //   'dbyq4bc3', //Cloud name
  //   'Restaurant_Dashboard', //Upload Preset name
  // );

  // static Future<String> uploadImageToCloudinary(File image) async {
  //   final response = await cloudinary.uploadFile(
  //     CloudinaryFile.fromFile(
  //       image.path,
  //       resourceType: CloudinaryResourceType.Image,
  //       folder: "restaurant_menu",
  //     ),
  //   );

  //   return response.secureUrl;
  // }

  static Future<void> addMenuItem({
    required String name,
    required String description,
    required String category,
    required num price,
    String? imageUrl,
  }) async {
    final docRef = _db
        .collection(_restaurantCollection)
        .doc(_restaurantId)
        .collection("menu")
        .doc();

    final id = docRef.id;

    // String imageUrl = "";

    // if (imageFile != null) {
    //   imageUrl = await uploadImageToCloudinary(imageFile);
    // }

    final item = MenuItem(
      id: id,
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
