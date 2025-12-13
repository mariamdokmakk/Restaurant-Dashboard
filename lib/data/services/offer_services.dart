import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rest_dashboard/data/models/menu_item.dart';
import 'package:rest_dashboard/data/models/offers_item.dart';

class OffersServices {
  static const String restaurantId = "UFrCk69XBDrXFMOCuMvB";

  static final offersRef = FirebaseFirestore.instance.collection("Offers");
  static final menuRef = FirebaseFirestore.instance
      .collection("Restaurant")
      .doc(restaurantId)
      .collection("menu");

  // update price of menu after offer
  static Future<void> _updateMenuItemsPrice(
    List<MenuItem> items,
    num discountPercent,
  ) async {
    for (var item in items) {
      final newPrice = item.price - (item.price * (discountPercent / 100));
      await menuRef.doc(item.id).update({"newPrice": newPrice});
    }
  }

  // create offer by selected category
  static Future<void> createOfferForCategory({
    required String title,
    required String category,
    required num discountPercent,
    required DateTime validFrom,
    required DateTime validTo,
  }) async {
    final offerId = offersRef.doc().id;
    final menuSnap = await menuRef.where("category", isEqualTo: category).get();

    //Get old offers for this category
    final oldOffersSnap = await offersRef
        .where("category", isEqualTo: category)
        .get();

    // Delete old offers
    for (var doc in oldOffersSnap.docs) {
      await doc.reference.delete();
    }

    List<MenuItem> menuItems = menuSnap.docs
        .map((doc) => MenuItem.fromMap(doc.data()))
        .toList();

    final offer = OffersItem(
      id: offerId,
      category: category,
      discountPercent: discountPercent,
      isActive: true,
      validFrom: validFrom,
      validTo: validTo,
      title: title,
    );

    await offersRef.doc(offerId).set(offer.toMap());
    await _updateMenuItemsPrice(menuItems, discountPercent);
  }

  // get All offers
  static Stream<List<OffersItem>> getAllOffers() {
    return offersRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => OffersItem.fromMap(doc.data()))
          .toList();
    });
  }

  static Future<void> deleteOffer(String id) {
    return offersRef.doc(id).delete();
  }
}
