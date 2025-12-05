// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rest_dashboard/data/models/menu_item.dart';
// import 'package:rest_dashboard/data/models/offers_item.dart';

// class OfferService {
//   static const String restaurantId = "UFrCk69XBDrXFMOCuMvB";

//   final offersRef = FirebaseFirestore.instance.collection("Offers");
//   final menuRef = FirebaseFirestore.instance
//       .collection("Restaurants")
//       .doc(restaurantId)
//       .collection("menu");
      
//   // update price of menu after offer
//   Future<void> _updateMenuItemsPrice(
//     List<MenuItem> items,
//     num discountPercent,
//   ) async {
//     for (var item in items) {
//       final newPrice = item.price - (item.price * (discountPercent / 100));

//       await menuRef.doc(item.id).update({
//         "newPrice": newPrice,
//         "hasOffer": true,
//       });
//     }
//   }

//   // create offer by selected category
//   Future<void> createOfferForCategory({
//     required String category,
//     required num discountPercent,
//     required DateTime validFrom,
//     required DateTime validTo,
//   }) async {
//     final offerId = offersRef.doc().id;

//     final menuSnap = await menuRef.where("category", isEqualTo: category).get();

//     List<MenuItem> menuItems = menuSnap.docs
//         .map((doc) => MenuItem.fromMap(doc.data()))
//         .toList();

//     final offer = OffersItem(
//       id: offerId,
//       category: category,
//       discount_percent: discountPercent,
//       is_active: true,
//       valid_from: validFrom,
//       valid_to: validTo,menu_item: menuItems,

//     );

//     await offersRef.doc(offerId).set(offer.toMap());
//     await _updateMenuItemsPrice(menuItems, discountPercent);
//   }

//   // get All offers
//   Stream<List<OffersItem>> getAllOffers() {
//     return offersRef.snapshots().map((snapshot) {
//       return snapshot.docs
//           .map((doc) => OffersItem.fromMap(doc.data()))
//           .toList();
//     });
//   }
// }
