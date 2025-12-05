// import 'package:flutter/material.dart';
// import 'package:rest_dashboard/data/models/offer.dart';
// import 'package:rest_dashboard/presentation/widgets/offer_card.dart';

// class AllOffersSection extends StatelessWidget {
//   final List<Offer> offers;
//   final Function(String) onDeleteOffer;

//   const AllOffersSection({
//     super.key,
//     required this.offers,
//     required this.onDeleteOffer,
//   });

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
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'All Offers (${offers.length})',
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(height: 20),
//           if (offers.isEmpty)
//             _buildEmptyState()
//           else
//             _buildOffersList(),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         children: [
//           Icon(
//             Icons.local_offer_outlined,
//             size: 80,
//             color: Colors.grey[300],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No offers created yet',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey[700],
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Create your first promotional offer above',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOffersList() {
//     return ListView.separated(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: offers.length,
//       separatorBuilder: (context, index) => const SizedBox(height: 0),
//       itemBuilder: (context, index) {
//         final offer = offers[index];
//         return OfferCard(
//           offer: offer,
//           onDelete: () => onDeleteOffer(offer.id),
//         );
//       },
//     );
//   }
// }

