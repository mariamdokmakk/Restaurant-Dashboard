import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rest_dashboard/data/services/dashboard_services.dart';
import 'package:rest_dashboard/presentation/screens/menu_screen.dart';
import 'package:rest_dashboard/presentation/screens/offers_screen.dart';
import 'dashboard_screen.dart';

class AdminLayout extends StatefulWidget {
  const AdminLayout({super.key});

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  int _selectedIndex = 0;
  StreamSubscription? _orderListener;

  // Define your screens here
  final List<Widget> _screens = [
    const DashboardScreen(),
    const MenuManagementScreen(),
    const OffersScreen(),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _orderListener = FirebaseFirestore.instance
          .collectionGroup("Orders")
          .snapshots()
          .listen((_) {
            DashboardServices.syncDailyOrderCounts();
          });
    });
  }

  @override
  void dispose() {
    _orderListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      // leading: IconButton(
      //   icon: const Icon(Icons.menu, color: Colors.black),
      //   onPressed: () {},
      // ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            child: Image.asset("assets/logo_img.png", width: 70),
          ),
          const SizedBox(width: 8),
          const Text(
            'To The Bone',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      // actions: [
      //   IconButton(
      //     icon: const Icon(Icons.search, color: Colors.black),
      //     onPressed: () {},
      //   ),
      //   Stack(
      //     alignment: Alignment.topRight,
      //     children: [
      //       IconButton(
      //         icon: const Icon(Icons.notifications_none, color: Colors.black),
      //         onPressed: () {},
      //       ),
      //       Positioned(
      //         right: 8,
      //         top: 8,
      //         child: Container(
      //           padding: const EdgeInsets.all(4),
      //           decoration: const BoxDecoration(
      //             color: Colors.orange,
      //             shape: BoxShape.circle,
      //           ),
      //           constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
      //         ),
      //       ),
      //     ],
      //   ),
      //   IconButton(
      //     icon: const Icon(Icons.account_circle_outlined, color: Colors.green),
      //     onPressed: () {},
      //   ),
      //   const SizedBox(width: 8),
      // ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF2ECC71),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),

        BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Menu'),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer_outlined),
          activeIcon: Icon(Icons.local_offer),
          label: 'Offers',
        ),
      ],
    );
  }
}
