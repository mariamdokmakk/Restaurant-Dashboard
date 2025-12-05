import 'package:flutter/material.dart';
import 'package:rest_dashboard/data/models/menu_item.dart';
import 'package:rest_dashboard/data/services/dashboard_services.dart';

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
              separatorBuilder: (context, index) => const SizedBox(height: 12),
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
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            item.imageUrl,
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
                item.category ?? "",
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
