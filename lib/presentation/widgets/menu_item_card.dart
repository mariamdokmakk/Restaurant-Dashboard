import 'package:flutter/material.dart';
import 'package:rest_dashboard/data/models/menu_item.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onDelete;

  const MenuItemCard({super.key, required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),

            child:
            
                // item.imageUrl.isNotEmpty
                // ?
                // ClipRRect(
                //     borderRadius: BorderRadius.circular(8),
                //     child: Image.network(
                //       item.imageUrl,
                //       fit: BoxFit.cover,
                //       width: 50,
                //       height: 50,
                //       errorBuilder: (context, error, stackTrace) {
                //         return const Icon(
                //           Icons.image_not_supported,
                //           color: Colors.grey,
                //         );
                //       },
                //     loadingBuilder: (context, child, progress) {
                //       if (progress == null) return child;
                //       return const Center(
                //         child: SizedBox(
                //           width: 20,
                //           height: 20,
                //           child: CircularProgressIndicator(strokeWidth: 2),
                //         ),
                //       );
                //     },
                //   ),
                // )
                // :
                const Icon(
                  Icons.restaurant_menu,
                  color: Color(0xFF4CAF50),
                  size: 24,
                ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.category,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${item.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(height: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: onDelete,
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
