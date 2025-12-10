class DailyStatus {
  final String id;
  final double earnings;
  final int completed;
  final int canceled;
  final int pending;
  // final int ordersCount;

  DailyStatus({
    required this.id,
    this.earnings = 0,
    this.completed = 0,
    this.canceled = 0,
    this.pending = 0,
    // this.ordersCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'earnings': earnings,
      'completed': completed,
      'canceled': canceled,
      'pending': pending,
      // 'ordersCount': ordersCount,
    };
  }

  factory DailyStatus.fromMap(Map<String, dynamic> map) {
    return DailyStatus(
      id: map['id'] as String,
      earnings: (map['earnings'] ?? 0).toDouble(),
      completed: (map['completed'] ?? 0) as int,
      canceled: (map['canceled'] ?? 0) as int,
      pending: (map['pending'] ?? 0) as int,
      // ordersCount: (map['ordersCount'] ?? 0) as int,
    );
  }
}
