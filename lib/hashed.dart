class Hashed {
  // static Stream<int> getDailyStatusField(String field) {
  //   DateTime now = DateTime.now();
  //   final docId = "${now.year}-${now.month}-${now.day}";

  //   return _db
  //       .collection(_restaurantCollection)
  //       .doc(_restaurantId)
  //       .collection(_dailyStatusCollection)
  //       .doc(docId)
  //       .snapshots()
  //       .map((snapshot) {
  //         if (!snapshot.exists || snapshot.data() == null) return 0;
  //         final status = DailyStatus.fromMap(snapshot.data()!);
  //         switch (field) {
  //           case 'completed':
  //             return status.completed;
  //           // case 'canceled':
  //           //   return status.canceled;
  //           // case 'pending':
  //           //   return status.pending;
  //           default:
  //             return 0;
  //         }
  //       });
  // }

  // static Stream<int> getDailyCanceledOrdersCount() {
  //   return _db
  //       .collectionGroup(_orderCollection)
  //       .snapshots()
  //       .map(
  //         (snapshot) => snapshot.docs
  //             .map((doc) => OrderItem.fromMap(doc.data()))
  //             .where((order) => order.orderState == 'canceled')
  //             .length,
  //       );
  // }

  // static Stream<int> getDailyPendingOrdersCount() {
  // return _db
  //     .collectionGroup(_orderCollection)
  //     .snapshots()
  //     .map(
  //       (snapshot) => snapshot.docs
  //           .map((doc) => OrderItem.fromMap(doc.data()))
  //           .where((order) => order.orderState == 'pending')
  //           .length,
  //     );
  // }

  //  static Future<void> updateOrderDailyStatus({
  //   required String id,
  //   required String userId,
  //   // required String oldState,
  //   required String newState,
  // }) async {
  //   final now = DateTime.now();
  //   final docId = "${now.year}-${now.month}-${now.day}";

  //   // Update the order state in user's collection
  //   await _db
  //       .collection(_userCollection)
  //       .doc(userId)
  //       .collection(_orderCollection)
  //       .doc(id)
  //       .update({'orderState': newState});

  //   final docRef = _db
  //       .collection(_restaurantCollection)
  //       .doc(_restaurantId)
  //       .collection(_dailyStatusCollection)
  //       .doc(docId);

  //   // If old was pending → remove from pending
  //   // if (oldState == "pending") {
  //   //   await docRef.update({'pending': FieldValue.increment(-1)});
  //   // }

  //   // If new is completed → increment completed
  //   if (newState == "completed") {
  //     await docRef.update({
  //       'completed': FieldValue.increment(1),
  //       'pending': FieldValue.increment(1),
  //     });
  //   }

  //   // If new is canceled → increment canceled
  //   if (newState == "canceled") {
  //     await docRef.update({
  //       'canceled': FieldValue.increment(1),
  //       'pending': FieldValue.increment(1),
  //     });
  //   }
  // }

  // the state changes with the change of the slide button
  // static Future<void> setCompleted({
  //   required String id,
  //   required String userId,
  // }) async {
  //   final now = DateTime.now();
  //   final docId = "${now.year}-${now.month}-${now.day}";

  //   // Update the order state in user's collection
  //   await _db
  //       .collection(_userCollection)
  //       .doc(userId)
  //       .collection(_orderCollection)
  //       .doc(id)
  //       .update({'orderState': "completed"});

  //   final docRef = _db
  //       .collection(_restaurantCollection)
  //       .doc(_restaurantId)
  //       .collection(_dailyStatusCollection)
  //       .doc(docId);

  //   await docRef.update({'completed': FieldValue.increment(1)});
  // }

  //call in init state
  // static Future<void> createStatusCollections() async {
  //   DateTime now = DateTime.now();
  //   int weekNum = ((now.day - 1) ~/ 7) + 1;
  //   if (weekNum > 4) weekNum = 4;

  //   final dayId = "${now.year}-${now.month}-${now.day}";
  //   final weekId = "${now.year}-${now.month}-W$weekNum";
  //   final monthId = "${now.year}-${now.month}";

  //   //start of the Day
  //   if (now.hour == 0) {
  //     await _db
  //         .collection(_restaurantCollection)
  //         .doc(_restaurantId)
  //         .collection(_dailyStatusCollection)
  //         .doc(dayId)
  //         .set({'id': dayId});
  //   }
  //   //start of the week
  //   if (now.weekday == 1 && now.hour == 0) {
  //     await _db
  //         .collection(_restaurantCollection)
  //         .doc(_restaurantId)
  //         .collection(_weeklyEarningCollection)
  //         .doc(weekId)
  //         .set({'id': weekId});
  //   }

  //   //start of the month
  //   if (now.day == 1 && now.hour == 0) {
  //     await _db
  //         .collection(_restaurantCollection)
  //         .doc(_restaurantId)
  //         .collection(_monthlyEarningCollection)
  //         .doc(monthId)
  //         .set({'id': monthId});
  //   }
  // }
}
