import 'package:flutter/material.dart';
import 'package:rest_dashboard/data/models/menu_item.dart';
import 'package:rest_dashboard/presentation/widgets/menu_item_card.dart';

class MenuItemsSection extends StatelessWidget {
  final List<MenuItem> menuItems;
  final Function(String) onDeleteItem;

  const MenuItemsSection({
    super.key,
    required this.menuItems,
    required this.onDeleteItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Menu Items (${menuItems.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          if (menuItems.isEmpty) _buildEmptyState() else _buildMenuItemsList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          Icon(Icons.restaurant_menu, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No menu items yet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first item using the form above',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItemsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menuItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return MenuItemCard(item: item, onDelete: () => onDeleteItem(item.id!));
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:rest_dashboard/data/services/menu_sarvice.dart';
// import 'package:rest_dashboard/presentation/widgets/menu_item_card.dart';

// class MenuItemsSection extends StatelessWidget {
//   final Function(String) onDeleteItem;

//   const MenuItemsSection({super.key, required this.onDeleteItem});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),

//       child: StreamBuilder(
//         stream: MenuService.getMenuItems(),
//         builder: (context, snapshot) {

//           //may be changed
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error loading menu'));
//           }

//           final data = snapshot.data ?? [];

//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Menu Items (${data.length})',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               if (data.isEmpty) _buildEmptyState() else _buildMenuItemsList(),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         children: [
//           Icon(Icons.restaurant_menu, size: 80, color: Colors.grey[300]),
//           const SizedBox(height: 16),
//           Text(
//             'No menu items yet',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey[700],
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Add your first item using the form above',
//             style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMenuItemsList() {
//     return StreamBuilder(
//       stream: MenuService.getMenuItems(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return Center(child: Text('Error loading menu'));
//         }

//         final data = snapshot.data ?? [];
//         if (data.isEmpty) return Center(child: Text("No menu items"));

//         return ListView.separated(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: data.length,
//           separatorBuilder: (context, index) => const SizedBox(height: 12),
//           itemBuilder: (context, index) {
//             final item = data[index];
//             return MenuItemCard(
//               item: item,
//               onDelete: () => onDeleteItem(item.id),
//             );
//           },
//         );
//       },
//     );
//   }
// }
