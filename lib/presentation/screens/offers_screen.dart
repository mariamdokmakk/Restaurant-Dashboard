// import 'package:flutter/material.dart';
// import 'package:rest_dashboard/data/models/offers_item.dart';
// import 'package:rest_dashboard/presentation/widgets/all_offers_section.dart';
// import 'package:rest_dashboard/presentation/widgets/create_offer_card.dart';

// class OffersScreen extends StatefulWidget {
//   final bool showBottomNav;
//   const OffersScreen({super.key, this.showBottomNav = true});

//   @override
//   State<OffersScreen> createState() => _OffersScreenState();
// }

// class _OffersScreenState extends State<OffersScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _promoCodeController = TextEditingController();
//   final _discountController = TextEditingController();
//   final _validFromController = TextEditingController();
//   final _validToController = TextEditingController();
//   String? _selectedCategory;
//   DateTime? _validFrom;
//   DateTime? _validTo;
//   final List<OffersItem> _offers = [];
//   final List<String> _categories = ["Burger", "Pizza", "Dessert", "Drink"];

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _promoCodeController.dispose();
//     _discountController.dispose();
//     _validFromController.dispose();
//     _validToController.dispose();
//     super.dispose();
//   }

//   void _createOffer() {
//     if (_formKey.currentState!.validate()) {
//       if (_validFrom == null || _validTo == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please select valid dates')),
//         );
//         return;
//       }

//       if (_validFrom!.isAfter(_validTo!)) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Valid From date must be before Valid To date'),
//           ),
//         );
//         return;
//       }

//       final newOffer = OffersItem(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         title: _titleController.text.trim(),
//         promoCode: _promoCodeController.text.trim().toUpperCase(),
//         discount: double.parse(_discountController.text.trim()),
//         validFrom: _validFrom!,
//         validTo: _validTo!,
//         category: _selectedCategory!,
//       );

//       setState(() {
//         _offers.add(newOffer);
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Offer created successfully')),
//       );

//       _titleController.clear();
//       _promoCodeController.clear();
//       _discountController.clear();
//       _validFromController.clear();
//       _validToController.clear();
//       setState(() {
//         _selectedCategory = null;
//         _validFrom = null;
//         _validTo = null;
//       });
//     }
//   }

//   void _deleteOffer(String id) {
//     setState(() {
//       _offers.removeWhere((offer) => offer.id == id);
//     });
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text('Offer deleted')));
//   }

//   void _onCategoryChanged(String? category) {
//     setState(() {
//       _selectedCategory = category;
//     });
//   }

//   Future<void> _selectValidFromDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _validFrom ?? DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );
//     if (picked != null) {
//       setState(() {
//         _validFrom = picked;
//         _validFromController.text = _formatDate(picked);
//       });
//     }
//   }

//   Future<void> _selectValidToDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _validTo ?? (_validFrom ?? DateTime.now()),
//       firstDate: _validFrom ?? DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );
//     if (picked != null) {
//       setState(() {
//         _validTo = picked;
//         _validToController.text = _formatDate(picked);
//       });
//     }
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeader(),
//             const SizedBox(height: 24),
//             CreateOfferCard(
//               formKey: _formKey,
//               titleController: _titleController,
//               promoCodeController: _promoCodeController,
//               discountController: _discountController,
//               validFromController: _validFromController,
//               validToController: _validToController,
//               selectedCategory: _selectedCategory,
//               categories: _categories,
//               onCategoryChanged: _onCategoryChanged,
//               onValidFromTap: _selectValidFromDate,
//               onValidToTap: _selectValidToDate,
//               onCreateOffer: _createOffer,
//             ),
//             const SizedBox(height: 24),
//             AllOffersSection(offers: _offers, onDeleteOffer: _deleteOffer),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Offers & Discounts',
//           style: TextStyle(
//             fontSize: 28,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         const SizedBox(height: 8),
//         const Text(
//           'Create and manage promotional offers',
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.grey,
//             fontWeight: FontWeight.normal,
//           ),
//         ),
//       ],
//     );
//   }
// }
