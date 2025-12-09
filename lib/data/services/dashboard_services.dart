import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rest_dashboard/data/models/daily_status.dart';
import 'package:rest_dashboard/data/models/menu_item.dart';
import 'package:rest_dashboard/data/models/order.dart';
import 'package:intl/intl.dart';

class DashboardServices {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _userCollection = "users";
  static const String _orderCollection = "Orders";
  static const String _restaurantCollection = "Restaurant";
  static const String _restaurantId = "UFrCk69XBDrXFMOCuMvB";
  static const String _dailyStatusCollection = 'DailyStatus';
  static const String _weeklyEarningCollection = 'weekly_earning';
  static const String _monthlyEarningCollection = 'monthly_earnings';
  static const String _menuCollection = 'menu';

  static Future<String> getUserName(String userId) async {
    final doc = await _db.collection(_userCollection).doc(userId).get();
    if (!doc.exists) return "Unknown";
    return doc.data()?['name'];
  }

  static Stream<int> getTotalUsersCount() {
    return _db
        .collection(_userCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  static Stream<String> getBestSeller() {
    return _db
        .collection(_restaurantCollection)
        .doc(_restaurantId)
        .collection(_menuCollection)
        .orderBy('totalOrderCount', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return "No items";
          final name = snapshot.docs.first.data()['name'];
          return name.toString();
        });
  }

  static Stream<List<MenuItem>> getBestSellers() {
    final queryStream = _db
        .collection(_restaurantCollection)
        .doc(_restaurantId)
        .collection(_menuCollection)
        .orderBy('totalOrderCount', descending: true)
        .limit(10)
        .snapshots();

    return queryStream.map(
      (snapshot) =>
          snapshot.docs.map((doc) => MenuItem.fromMap(doc.data())).toList(),
    );
  }

  //get all orders and display them in dashboard
  static Stream<List<OrderItem>> getOrders() {
    _db.collectionGroup("Orders").get().then((s) {
      print("FOUND ORDERS: ${s.docs.length}");
    });
    return _db
        .collectionGroup(_orderCollection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderItem.fromMap(doc.data()))
              .where(
                (order) =>
                    (order.orderState != 'canceled' &&
                    order.orderState != 'completed'),
              )
              .toList(),
        );
  }

  //field  --> pending ,completed ,canceled
  static Stream<int> getDailyOrdersCount(String field) {
    return _db.collectionGroup(_orderCollection).snapshots().map((snapshot) {
      final now = DateTime.now();

      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      return snapshot.docs
          .map((doc) => OrderItem.fromMap(doc.data()))
          .where(
            (order) =>
                order.orderState == field &&
                order.createdAt.isAfter(startOfDay) &&
                order.createdAt.isBefore(endOfDay),
          )
          .length;
    });
  }

  //I can remove this and just increment in the get pending ,completed ,canceled functions
  static Future<void> syncDailyOrderCounts() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final docId = "${now.year}-${now.month}-${now.day}";

    final snapshot = await _db.collectionGroup(_orderCollection).get();

    int pending = 0;
    int canceled = 0;
    int completed = 0;

    for (var doc in snapshot.docs) {
      final order = OrderItem.fromMap(doc.data());

      // check date
      if (order.createdAt.isAfter(startOfDay) &&
          order.createdAt.isBefore(endOfDay)) {
        if (order.orderState == "pending") pending++;
        if (order.orderState == "canceled") canceled++;
        if (order.orderState == "completed") completed++;
      }
    }

    // update daily doc
    final dailyRef = _db
        .collection(_restaurantCollection)
        .doc(_restaurantId)
        .collection(_dailyStatusCollection)
        .doc(docId);

    await dailyRef.set({
      "id": docId,
      "pending": pending,
      "canceled": canceled,
      "completed": completed,
    }, SetOptions(merge: true));
  }

  static Future<void> updateOrderDailyStatus({
    required String id,
    required String userId,
    required String orderState,
  }) async {
    // Update the order state in user's collection
    await _db
        .collection(_userCollection)
        .doc(userId)
        .collection(_orderCollection)
        .doc(id)
        .update({'orderState': orderState});
  }

  static Stream<double> getDayEarnings() {
    DateTime now = DateTime.now();
    final docId = "${now.year}-${now.month}-${now.day}";

    return _db
        .collection(_restaurantCollection)
        .doc(_restaurantId)
        .collection(_dailyStatusCollection)
        .doc(docId)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists || snapshot.data() == null) return 0.0;
          final earnings = DailyStatus.fromMap(snapshot.data()!).earnings;
          return earnings;
        });
  }

  static Stream<double?> getWeekEarnings(int weekNum, int monthNum) {
    DateTime now = DateTime.now();
    final docId = "${now.year}-$monthNum-W$weekNum";

    return _db
        .collection(_restaurantCollection)
        .doc(_restaurantId)
        .collection(_weeklyEarningCollection)
        .doc(docId)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists) return null;
          return (snapshot['earnings']) as double;
        });
  }

  static Stream<double?> getMonthEarnings(int year, int monthNum) {
    final docId = "$year-$monthNum";

    return _db
        .collection(_restaurantCollection)
        .doc(_restaurantId)
        .collection(_monthlyEarningCollection)
        .doc(docId)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists) return 0;
          return (snapshot['earnings']) as double;
        });
  }

  //When an order is marked as "completed", call these:
  static Future<void> addToEarnings(double orderTotal) async {
    DateTime now = DateTime.now();
    final dayId = "${now.year}-${now.month}-${now.day}";
    final monthId = "${now.year}-${now.month}";

    int weekNum = ((now.day - 1) ~/ 7) + 1;
    if (weekNum > 4) weekNum = 4;

    final weekId = "${now.year}-${now.month}-W$weekNum";

    //addToDailyEarnings
    await _db
        .collection(_restaurantCollection)
        .doc(_restaurantId)
        .collection(_dailyStatusCollection)
        .doc(dayId)
        .set({
          'earnings': FieldValue.increment(orderTotal),
        }, SetOptions(merge: true));

    //addToMonthlyEarnings
    await _db
        .collection(_restaurantCollection)
        .doc(_restaurantId)
        .collection(_monthlyEarningCollection)
        .doc(monthId)
        .set({
          'earnings': FieldValue.increment(orderTotal),
        }, SetOptions(merge: true));

    //addToWeeklyEarnings
    await _db
        .collection(_restaurantCollection)
        .doc(_restaurantId)
        .collection(_weeklyEarningCollection)
        .doc(weekId)
        .set({
          'earnings': FieldValue.increment(orderTotal),
        }, SetOptions(merge: true));
  }

  /////////////////////////charts//////////////////////////////////////

  // static Stream<List<Map<String, dynamic>>> getWeeklyStats() {
  //   final  docs = _db
  //       .collection(_dailyStatusCollection)
  //       .orderBy(FieldPath.documentId)
  //       .limit(7)
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs.map((d) => d.data()).toList());
  //   while (docs.length < 7) {
  //     docs.insert(0, {"completed": 0, "pending": 0, "canceled": 0});
  //   }
  //   return docs;
  // }

  static Stream<List<Map<String, dynamic>>> getWeeklyStats() {
    return _db.collection(_dailyStatusCollection).limit(7).snapshots().map((
      snapshot,
    ) {
      final List<Map<String, dynamic>> data = snapshot.docs
          .map((d) => d.data())
          .toList();
      // Sort manually (if data has a 'date' field)
      data.sort((a, b) => a['date'].compareTo(b['date']));
      while (data.length < 7) {
        data.insert(0, {"completed": 0, "pending": 0, "canceled": 0});
      }
      return data;
    });
  }

  static Stream<double?> getEarningsStream(
    int filter, {
    int? weekNum,
    int? monthNum,
  }) {
    DateTime now = DateTime.now();
    switch (filter) {
      case 0: // This Month - show weekly earnings
        return Stream.fromIterable(List.generate(4, (i) => i + 1))
            .asyncMap(
              (week) =>
                  DashboardServices.getWeekEarnings(week, now.month).first,
            )
            .asBroadcastStream();
      case 1: // This Year - show monthly earnings
        return Stream.fromIterable(List.generate(12, (i) => i + 1))
            .asyncMap(
              (month) =>
                  DashboardServices.getMonthEarnings(now.year, month).first,
            )
            .asBroadcastStream();
      case 2: // Last Year - show monthly earnings
        return Stream.fromIterable(List.generate(12, (i) => i + 1))
            .asyncMap(
              (month) =>
                  DashboardServices.getMonthEarnings(now.year - 1, month).first,
            )
            .asBroadcastStream();
      default:
        return Stream.value(0.0);
    }
  }

  static Future<void> createStatusCollections() async {
    DateTime now = DateTime.now();
    int weekNum = ((now.day - 1) ~/ 7) + 1;
    if (weekNum > 4) weekNum = 4;

    final dayId = "${now.year}-${now.month}-${now.day}";
    final weekId = "${now.year}-${now.month}-W$weekNum";
    final monthId = "${now.year}-${now.month}";

    //start of the Day
    if (now.hour == 0) {
      await _db
          .collection(_restaurantCollection)
          .doc(_restaurantId)
          .collection(_dailyStatusCollection)
          .doc(dayId)
          .set({'id': dayId});
    }
    //start of the week
    if (now.weekday == 1 && now.hour == 0) {
      await _db
          .collection(_restaurantCollection)
          .doc(_restaurantId)
          .collection(_weeklyEarningCollection)
          .doc(weekId)
          .set({'id': weekId});
    }

    //start of the month
    if (now.day == 1 && now.hour == 0) {
      await _db
          .collection(_restaurantCollection)
          .doc(_restaurantId)
          .collection(_monthlyEarningCollection)
          .doc(monthId)
          .set({'id': monthId});
    }
  }
}
