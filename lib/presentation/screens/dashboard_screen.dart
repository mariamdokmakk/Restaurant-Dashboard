import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:rest_dashboard/data/models/menu_item.dart';
import 'package:rest_dashboard/data/models/order.dart';
import 'package:rest_dashboard/data/services/dashboard_services.dart';
import 'package:rest_dashboard/presentation/widgets/buildStreamStatCard.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // int _selectedChartFilter = 0;

  int _touchedIndex = -1; // For Bar Chart
  final List<String> _statusOptions = [
    'pending',
    'preparing',
    'on the Way',
    'completed',
    'canceled',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsGrid(),
          const SizedBox(height: 20),
          _buildTotalSalesCard(),
          const SizedBox(height: 20),
          // _buildSalesChartCard(),
          // const SizedBox(height: 20),
          _buildOrdersOverviewCard(),
          const SizedBox(height: 20),
          _buildOrderControlSection(),
          const SizedBox(height: 20),
          buildBestSellingSection(),
          const SizedBox(height: 20),
          // _buildUserGrowthCard(),
          // const SizedBox(height: 20),
          // _buildRecentOrdersSection(),
          // const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOrdersOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Orders Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Orders breakdown by status',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          SizedBox(height: 250, child: _buildBarChart()),
          const SizedBox(height: 16),
          _buildBarChartLegend(),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: DashboardServices.getWeeklyStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error loading chart"));
        }

        final data = snapshot.data ?? [];

        if (data.length < 7) {
          return const Center(child: Text("Not enough data for chart"));
        }

        return BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 20,
            minY: 0,
            baselineY: 10,
            barTouchData: BarTouchData(
              enabled: true,
              touchCallback: (FlTouchEvent event, barTouchResponse) {
                if (!event.isInterestedForInteractions ||
                    barTouchResponse == null ||
                    barTouchResponse.spot == null) {
                  setState(() {
                    _touchedIndex = -1;
                  });
                  return;
                }
                setState(() {
                  _touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                });
              },
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (group) => Colors.white,
                tooltipMargin: 8,
                tooltipPadding: const EdgeInsets.all(10),
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  String weekDay;
                  switch (group.x) {
                    case 0:
                      weekDay = 'Mon';
                      break;
                    case 1:
                      weekDay = 'Tue';
                      break;
                    case 2:
                      weekDay = 'Wed';
                      break;
                    case 3:
                      weekDay = 'Thu';
                      break;
                    case 4:
                      weekDay = 'Fri';
                      break;
                    case 5:
                      weekDay = 'Sat';
                      break;
                    case 6:
                      weekDay = 'Sun';
                      break;
                    default:
                      weekDay = '';
                  }
                  return BarTooltipItem(
                    '$weekDay\n',
                    const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'canceled : ${group.barRods[2].toY.toInt()}\n',
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: 'completed : ${group.barRods[0].toY.toInt()}\n',
                        style: const TextStyle(
                          color: Color(0xFF2ECC71),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: 'pending : ${group.barRods[1].toY.toInt()}',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final isTouched = value.toInt() == _touchedIndex;
                    final style = TextStyle(
                      color: isTouched ? Colors.black : Colors.grey,
                      fontWeight: isTouched
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 12,
                    );
                    switch (value.toInt()) {
                      case 0:
                        return Text('Sat', style: style);
                      case 1:
                        return Text('Sun', style: style);
                      case 2:
                        return Text('Mon', style: style);
                      case 3:
                        return Text('Tue', style: style);
                      case 4:
                        return Text('Wed', style: style);
                      case 5:
                        return Text('Thu', style: style);
                      case 6:
                        return Text('Fri', style: style);
                      default:
                        return const Text('');
                    }
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  interval: 30,
                  getTitlesWidget: (value, meta) {
                    if (value == 0)
                      return const Text(
                        '0',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      );
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 30,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.grey.withOpacity(0.1),
                strokeWidth: 1,
                dashArray: [5, 5],
              ),
              getDrawingVerticalLine: (value) => FlLine(
                color: Colors.grey.withOpacity(0.1),
                strokeWidth: 1,
                dashArray: [5, 5],
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(7, (index) {
              final day = data[index];
              return _makeGroupData(
                index,
                (day['completed'] ?? 0).toDouble(),
                (day['pending'] ?? 0).toDouble(),
                (day['canceled'] ?? 0).toDouble(),
              );
            }),
          ),
        );
      },
    );
  }

  BarChartGroupData _makeGroupData(
    int x,
    double completed,
    double pending,
    double canceled,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: completed,
          color: const Color(0xFF2ECC71),
          width: 6,
          borderRadius: BorderRadius.circular(2),
        ),
        BarChartRodData(
          toY: pending,
          color: Colors.orange,
          width: 6,
          borderRadius: BorderRadius.circular(2),
        ),
        BarChartRodData(
          toY: canceled,
          color: Colors.redAccent,
          width: 6,
          borderRadius: BorderRadius.circular(2),
        ),
      ],
      barsSpace: 4,
    );
  }

  Widget _buildBarChartLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem('canceled', Colors.redAccent),
        const SizedBox(width: 24),
        _legendItem('completed', const Color(0xFF2ECC71)),
        const SizedBox(width: 24),
        _legendItem('pending', Colors.orange),
      ],
    );
  }

  Widget _legendItem(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: buildStreamStatCard<int>(
                stream: DashboardServices.getTotalUsersCount(),
                title: "Total Users",
                formatter: (count) => count > 1000
                    ? "${(count / 1000).toStringAsFixed(1)}K"
                    : count.toString(),
                // trend: "↑ +12.5%",
                trendColor: Colors.green,
                icon: Icons.people_outline,
                iconColor: Colors.blue,
                iconBgColor: Colors.blue.shade50,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: buildStreamStatCard<double?>(
                stream: DashboardServices.getDayEarnings(),
                title: "Earnings Today",
                icon: Icons.attach_money,
                iconColor: Colors.green,
                iconBgColor: Colors.green.shade50,
                trendColor: Colors.green,
                formatter: (value) {
                  if (value == null) return "0.0";
                  if (value >= 1000) {
                    return "${(value / 1000).toStringAsFixed(1)}K";
                  } else {
                    return value.toStringAsFixed(1);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: buildStreamStatCard<String>(
                stream: DashboardServices.getBestSeller(),
                title: "Best Seller",
                icon: Icons.restaurant,
                iconColor: Colors.orange,
                iconBgColor: Colors.orange.shade50,
                trendColor: Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: buildStreamStatCard<int>(
                stream: DashboardServices.getDailyOrdersCount("canceled"),
                title: "Canceled",
                icon: Icons.cancel_outlined,
                iconColor: Colors.red,
                iconBgColor: Colors.red.shade50,
                trendColor: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: buildStreamStatCard<int>(
                stream: DashboardServices.getDailyOrdersCount("pending"),
                title: "Pending",
                icon: Icons.access_time,
                iconColor: Colors.orange,
                iconBgColor: Colors.orange.shade50,
                trendColor: Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: buildStreamStatCard<int>(
                stream: DashboardServices.getDailyOrdersCount("completed"),
                title: "Completed",
                icon: Icons.check_circle_outline,
                iconColor: Colors.green,
                iconBgColor: Colors.green.shade50,
                trendColor: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalSalesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Total Sales This Month',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              Text(
                'Last Month',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StreamBuilder<double?>(
                stream: DashboardServices.getMonthEarnings(
                  DateTime.now().year,
                  DateTime.now().month,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("...");
                  }
                  if (!snapshot.hasData) {
                    return Text("0.0");
                  }
                  if (snapshot.hasError) {
                    return Text("Error");
                  }
                  return Text(
                    snapshot.data.toString(),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  );
                },
              ),

              StreamBuilder<double?>(
                stream: DashboardServices.getMonthEarnings(
                  DateTime.now().year,
                  DateTime.now().month == 1 ? 12 : DateTime.now().month - 1,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("...");
                  }
                  if (!snapshot.hasData) {
                    return Text("0.0");
                  }
                  if (snapshot.hasError) {
                    return Text("Error");
                  }

                  return Text(
                    snapshot.data.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Row(
          //   children: const [
          //     Icon(Icons.trending_up, color: Colors.green, size: 20),
          //     SizedBox(width: 4),
          //     Text(
          //       '+18.4% vs last month',
          //       style: TextStyle(
          //         color: Colors.green,
          //         fontSize: 14,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return "just now";
    } else if (diff.inMinutes < 60) {
      return "${diff.inMinutes} min ago";
    } else if (diff.inHours < 24) {
      return "${diff.inHours} hours ago";
    } else if (diff.inDays == 1) {
      return "yesterday";
    } else {
      return "${diff.inDays} days ago";
    }
  }

  Widget _buildOrderItem(OrderItem order, int count) {
    Color statusColor = _getStatusColor(order.orderState);
    IconData statusIcon = _getStatusIcon(order.orderState);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: "Order:$count  ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: _timeAgo(order.createdAt),
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[500],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "\$${order.totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          FutureBuilder<String>(
            future: DashboardServices.getUserName(order.userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading...");
              }

              if (snapshot.hasError) {
                return const Text("Error");
              }

              final name = snapshot.data ?? "Unknown";

              return Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              );
            },
          ),
          Text(order.address, style: const TextStyle(color: Colors.black)),
          Divider(),
          for (var item in order.items)
            Text(
              "${item["name"]}: ${item["quantity"]}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 14, color: statusColor),
                    const SizedBox(width: 6),
                    Text(
                      order.orderState,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: order.orderState,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey[400],
                      ),
                      isExpanded: true,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                      onChanged: (String? newValue) async {
                        if (_statusOptions.toSet().length ==
                            _statusOptions.length)
                          print('Duplicate values found in status options');
                        if (newValue == null) return;
                        setState(() {
                          order.orderState = newValue;
                        });
                        await DashboardServices.updateOrderDailyStatus(
                          id: order.id,
                          userId: order.userId,
                          orderState: newValue,
                        );
                        await DashboardServices.syncDailyOrderCounts();
                        if (newValue == "completed") {
                          await DashboardServices.addToEarnings(
                            order.totalPrice,
                          );
                          await DashboardServices.addtoTotalOrderCount(order);
                        }
                      },
                      items: _statusOptions
                          .map<DropdownMenuItem<String>>(
                            (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderControlSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Control',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Manage order status',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          StreamBuilder(
            stream: DashboardServices.getOrders(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error loading orders'));
              }

              final data = snapshot.data ?? [];
              if (data.isEmpty) return Center(child: Text("No pending orders"));
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _buildOrderItem(data[index], index + 1),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'preparing':
        return Colors.blue;
      case 'on the Way':
        return Colors.purple;
      case 'completed':
        return const Color(0xFF2ECC71);
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.access_time_rounded;
      case 'preparing':
        return Icons.soup_kitchen_outlined;
      case 'on the Way':
        return Icons.delivery_dining_outlined;
      case 'completed':
        return Icons.check_circle_outline;
      case 'canceled':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Widget buildBestSellingSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Best Selling Items',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Top performing menu items',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          StreamBuilder<List<MenuItem>>(
            stream: DashboardServices.getBestSellers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error loading best sellers'));
              }

              final data = snapshot.data ?? [];
              if (data.isEmpty) return Center(child: Text("No Best Sellers"));

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _buildBestSellerItem(data[index]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBestSellerItem(MenuItem item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          item.imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    item.imageUrl!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: const Icon(Icons.fastfood, color: Colors.grey),
                    ),
                  ),
                )
              : Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.restaurant_menu,
                    color: Color(0xFF4CAF50),
                    size: 24,
                  ),
                ),

          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    // if (item.isTop) ...[
                    //   const SizedBox(width: 6),
                    //   const Icon(Icons.star, color: Colors.orange, size: 16),
                    // ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.category,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      item.totalOrderCount.toString(),
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // Text(' • ', style: TextStyle(color: Colors.grey[400])),
                    // Text(
                    //   item.revenue,
                    //   style: TextStyle(
                    //     color: Colors.grey[800],
                    //     fontSize: 13,
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              // const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
              // const SizedBox(width: 4),
              // Text(
              //   item.rating.toString(),
              //   style: const TextStyle(
              //     fontWeight: FontWeight.bold,
              //     fontSize: 15,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////
  //////////////coming soon features//////////////
  ////////////////////////////////////////////////

  // --- Stats and Charts (Unchanged) ---
  // List<FlSpot> _getChartData() {
  //   switch (_selectedChartFilter) {
  //     case 0:
  //       return const [
  //         FlSpot(0, 12000),
  //         FlSpot(1, 14500),
  //         FlSpot(2, 17500),
  //         FlSpot(3, 16500),
  //       ];
  //     case 1:
  //       return const [
  //         FlSpot(0, 15000),
  //         FlSpot(1, 18500),
  //         FlSpot(2, 22000),
  //         FlSpot(3, 23500),
  //       ];
  //     case 2:
  //       return const [
  //         FlSpot(0, 10000),
  //         FlSpot(1, 16000),
  //         FlSpot(2, 13000),
  //         FlSpot(3, 11000),
  //       ];
  //     default:
  //       return const [];
  //   }
  // }

  // Widget _buildLineChart() {
  //   final stream = DashboardServices.getEarningsStream(_selectedChartFilter);

  //   return StreamBuilder<double?>(
  //     stream: stream,
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) {
  //         return const Center(child: CircularProgressIndicator());
  //       }

  //       // For simplicity, let's mock a list of 4-12 points for chart
  //       // You can fetch multiple streams and merge later
  //       final spots = <FlSpot>[
  //         FlSpot(0, snapshot.data ?? 0),
  //         FlSpot(1, snapshot.data ?? 0),
  //         FlSpot(2, snapshot.data ?? 0),
  //         FlSpot(3, snapshot.data ?? 0),
  //       ];

  //       return AnimatedSwitcher(
  //         duration: const Duration(milliseconds: 300),
  //         child: LineChart(
  //           duration: const Duration(milliseconds: 250),
  //           curve: Curves.easeInOut,
  //           LineChartData(
  //             gridData: FlGridData(
  //               show: true,
  //               drawVerticalLine: true,
  //               horizontalInterval: 5000,
  //               verticalInterval: 1,
  //               getDrawingHorizontalLine: (value) => FlLine(
  //                 color: Colors.grey.withOpacity(0.1),
  //                 strokeWidth: 1,
  //                 dashArray: [5, 5],
  //               ),
  //               getDrawingVerticalLine: (value) => FlLine(
  //                 color: Colors.grey.withOpacity(0.1),
  //                 strokeWidth: 1,
  //                 dashArray: [5, 5],
  //               ),
  //             ),
  //             titlesData: FlTitlesData(
  //               show: true,
  //               rightTitles: AxisTitles(
  //                 sideTitles: SideTitles(showTitles: false),
  //               ),
  //               topTitles: AxisTitles(
  //                 sideTitles: SideTitles(showTitles: false),
  //               ),
  //               bottomTitles: AxisTitles(
  //                 sideTitles: SideTitles(
  //                   showTitles: true,
  //                   reservedSize: 30,
  //                   interval: 1,
  //                   getTitlesWidget: (value, meta) {
  //                     const style = TextStyle(color: Colors.grey, fontSize: 12);
  //                     switch (value.toInt()) {
  //                       case 0:
  //                         return const Text('W1', style: style);
  //                       case 1:
  //                         return const Text('W2', style: style);
  //                       case 2:
  //                         return const Text('W3', style: style);
  //                       case 3:
  //                         return const Text('W4', style: style);
  //                       default:
  //                         return Container();
  //                     }
  //                   },
  //                 ),
  //               ),
  //               leftTitles: AxisTitles(
  //                 sideTitles: SideTitles(
  //                   showTitles: true,
  //                   interval: 5000,
  //                   getTitlesWidget: (value, meta) {
  //                     if (value == 0) {
  //                       return const Text(
  //                         '0',
  //                         style: TextStyle(color: Colors.grey, fontSize: 12),
  //                       );
  //                     }
  //                     return Text(
  //                       '${(value / 1000).toInt()}k',
  //                       style: const TextStyle(
  //                         color: Colors.grey,
  //                         fontSize: 12,
  //                       ),
  //                     );
  //                   },
  //                   reservedSize: 40,
  //                 ),
  //               ),
  //             ),
  //             borderData: FlBorderData(show: false),
  //             minX: 0,
  //             maxX: spots.length - 1.toDouble(),
  //             minY: 0,
  //             maxY:
  //                 (spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.2),
  //             lineBarsData: [
  //               LineChartBarData(
  //                 spots: spots,
  //                 isCurved: true,
  //                 color: const Color(0xFF2ECC71),
  //                 barWidth: 3,
  //                 isStrokeCapRound: true,
  //                 dotData: FlDotData(show: false),
  //                 belowBarData: BarAreaData(
  //                   show: true,
  //                   color: const Color(0xFF2ECC71).withOpacity(0.15),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildSalesChartCard() {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(color: Colors.grey.shade200),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.02),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           'Sales Over Time',
  //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //         ),
  //         const SizedBox(height: 16),
  //         _buildChartFilterButtons(),
  //         const SizedBox(height: 24),
  //         SizedBox(height: 250, child: _buildLineChart()),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildChartFilterButtons() {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Row(
  //       spacing: 8,
  //       children: [
  //         _buildFilterButton(0, 'This Month'),
  //         _buildFilterButton(1, 'This Year'),
  //         _buildFilterButton(2, 'Last Year'),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildFilterButton(int index, String text) {
  //   final isSelected = _selectedChartFilter == index;
  //   return InkWell(
  //     onTap: () => setState(() => _selectedChartFilter = index),
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //       decoration: BoxDecoration(
  //         color: isSelected ? const Color(0xFF2ECC71) : Colors.grey[100],
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       child: Text(
  //         text,
  //         style: TextStyle(
  //           color: isSelected ? Colors.white : Colors.grey[600],
  //           fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // --- User Growth Section (Unchanged) ---
  // Widget _buildUserGrowthCard() {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(color: Colors.grey.shade200),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.02),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           'User Growth',
  //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //         ),
  //         const SizedBox(height: 4),
  //         Text(
  //           'Registered users over time',
  //           style: TextStyle(fontSize: 14, color: Colors.grey[600]),
  //         ),
  //         const SizedBox(height: 24),
  //         SizedBox(height: 250, child: _buildUserGrowthChart()),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildUserGrowthChart() {
  //   return LineChart(
  //     LineChartData(
  //       gridData: FlGridData(
  //         show: true,
  //         drawVerticalLine: true,
  //         horizontalInterval: 1500,
  //         verticalInterval: 1,
  //         getDrawingHorizontalLine: (value) => FlLine(
  //           color: Colors.grey.withOpacity(0.1),
  //           strokeWidth: 1,
  //           dashArray: [5, 5],
  //         ),
  //         getDrawingVerticalLine: (value) => FlLine(
  //           color: Colors.grey.withOpacity(0.1),
  //           strokeWidth: 1,
  //           dashArray: [5, 5],
  //         ),
  //       ),
  //       titlesData: FlTitlesData(
  //         show: true,
  //         rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //         topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //         bottomTitles: AxisTitles(
  //           sideTitles: SideTitles(
  //             showTitles: true,
  //             reservedSize: 30,
  //             interval: 1,
  //             getTitlesWidget: (value, meta) {
  //               const style = TextStyle(color: Colors.grey, fontSize: 12);
  //               switch (value.toInt()) {
  //                 case 0:
  //                   return const Text('Jan', style: style);
  //                 case 1:
  //                   return const Text('Feb', style: style);
  //                 case 2:
  //                   return const Text('Mar', style: style);
  //                 case 3:
  //                   return const Text('Apr', style: style);
  //                 case 4:
  //                   return const Text('May', style: style);
  //                 case 5:
  //                   return const Text('Jun', style: style);
  //                 default:
  //                   return const Text('');
  //               }
  //             },
  //           ),
  //         ),
  //         leftTitles: AxisTitles(
  //           sideTitles: SideTitles(
  //             showTitles: true,
  //             interval: 1500,
  //             reservedSize: 40,
  //             getTitlesWidget: (value, meta) {
  //               return Text(
  //                 value.toInt().toString(),
  //                 style: const TextStyle(color: Colors.grey, fontSize: 12),
  //               );
  //             },
  //           ),
  //         ),
  //       ),
  //       borderData: FlBorderData(
  //         show: true,
  //         border: Border(
  //           left: BorderSide(color: Colors.grey.withOpacity(0.5)),
  //           bottom: BorderSide(color: Colors.grey.withOpacity(0.5)),
  //           right: BorderSide.none,
  //           top: BorderSide.none,
  //         ),
  //       ),
  //       minX: 0,
  //       maxX: 5,
  //       minY: 0,
  //       maxY: 6000,
  //       lineTouchData: LineTouchData(
  //         enabled: true,
  //         touchTooltipData: LineTouchTooltipData(
  //           getTooltipColor: (spot) => Colors.white,
  //           tooltipPadding: const EdgeInsets.all(8),
  //           getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
  //             return touchedBarSpots.map((barSpot) {
  //               String month = '';
  //               switch (barSpot.x.toInt()) {
  //                 case 0:
  //                   month = 'Jan';
  //                   break;
  //                 case 1:
  //                   month = 'Feb';
  //                   break;
  //                 case 2:
  //                   month = 'Mar';
  //                   break;
  //                 case 3:
  //                   month = 'Apr';
  //                   break;
  //                 case 4:
  //                   month = 'May';
  //                   break;
  //                 case 5:
  //                   month = 'Jun';
  //                   break;
  //               }
  //               return LineTooltipItem(
  //                 '$month\n',
  //                 const TextStyle(
  //                   color: Colors.black,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 14,
  //                 ),
  //                 children: [
  //                   TextSpan(
  //                     text: 'users : ${barSpot.y.toInt()}',
  //                     style: const TextStyle(
  //                       color: Colors.orange,
  //                       fontSize: 12,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ],
  //               );
  //             }).toList();
  //           },
  //         ),
  //       ),
  //       lineBarsData: [
  //         LineChartBarData(
  //           spots: const [
  //             FlSpot(0, 1200),
  //             FlSpot(1, 1900),
  //             FlSpot(2, 2400),
  //             FlSpot(3, 2800),
  //             FlSpot(4, 3500),
  //             FlSpot(5, 4200),
  //           ],
  //           isCurved: false,
  //           color: Colors.orange,
  //           barWidth: 3,
  //           isStrokeCapRound: true,
  //           dotData: FlDotData(
  //             show: true,
  //             getDotPainter: (spot, percent, barData, index) =>
  //                 FlDotCirclePainter(
  //                   radius: 4,
  //                   color: Colors.orange,
  //                   strokeWidth: 2,
  //                   strokeColor: Colors.white,
  //                 ),
  //           ),
  //           belowBarData: BarAreaData(show: false),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // --- NEW: Recent Orders Section ---
  // Widget _buildRecentOrdersSection() {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(color: Colors.grey.shade200),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.02),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           'Recent Orders',
  //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //         ),
  //         const SizedBox(height: 4),
  //         Text(
  //           'Latest customer orders',
  //           style: TextStyle(fontSize: 14, color: Colors.grey[600]),
  //         ),
  //         const SizedBox(height: 20),
  //         StreamBuilder(stream: Dash, builder: builder)

  //         ListView.separated(
  //           shrinkWrap: true,
  //           physics: const NeverScrollableScrollPhysics(),
  //           itemCount: _recentOrders.length,
  //           separatorBuilder: (context, index) => const SizedBox(height: 12),
  //           itemBuilder: (context, index) =>
  //               _buildRecentOrderItem(_recentOrders[index]),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildRecentOrderItem(_RecentOrder order) {
  //   Color statusColor = _getStatusColor(order.status); // Reuse helper
  //   Color statusBg = statusColor.withOpacity(0.1);
  //  // Special handling for lowercase matching if needed, but helper handles standard cases.
  //   // The helper expects "Completed", "Pending", "Canceled" (Capitalized).
  //   // The data has lowercase, so let's capitalize strictly for the helper or adjust helper.
  //   // Let's just fix the case for display logic here:
  //   if (order.status == 'completed') statusColor = const Color(0xFF2ECC71);
  //   if (order.status == 'pending') statusColor = Colors.orange;
  //   if (order.status == 'canceled') statusColor = Colors.redAccent;
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFF8F9FA),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Row(
  //       children: [
  //         // Avatar
  //         CircleAvatar(
  //           radius: 24,
  //           backgroundColor: const Color(0xFFE8F5E9), // Light green bg
  //           child: Text(
  //             order.initials,
  //             style: const TextStyle(
  //               color: Color(0xFF2ECC71), // Darker green text
  //               fontWeight: FontWeight.bold,
  //               fontSize: 16,
  //             ),
  //           ),
  //         ),
  //         const SizedBox(width: 16),
  //         // Text Info
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 children: [
  //                   Text(
  //                     order.name,
  //                     style: const TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 15,
  //                       color: Colors.black87,
  //                     ),
  //                   ),
  //                   const SizedBox(width: 6),
  //                   Text(
  //                     order.id,
  //                     style: TextStyle(color: Colors.grey[400], fontSize: 14),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 4),
  //               Text(
  //                 order.item,
  //                 style: TextStyle(color: Colors.grey[600], fontSize: 13),
  //               ),
  //               const SizedBox(height: 4),
  //               Row(
  //                 children: [
  //                   Text(
  //                     order.price,
  //                     style: const TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 14,
  //                       color: Colors.black87,
  //                     ),
  //                   ),
  //                   const SizedBox(width: 8),
  //                   Text('•', style: TextStyle(color: Colors.grey[400])),
  //                   const SizedBox(width: 8),
  //                   Text(
  //                     order.time,
  //                     style: TextStyle(color: Colors.grey[500], fontSize: 13),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //         // Status Badge
  //         Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //           decoration: BoxDecoration(
  //             color: statusColor.withOpacity(0.15),
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: Text(
  //             order.status,
  //             style: TextStyle(
  //               color: statusColor,
  //               fontWeight: FontWeight.bold,
  //               fontSize: 12,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
