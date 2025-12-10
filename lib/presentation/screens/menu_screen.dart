import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rest_dashboard/data/services/menu_services.dart';
import 'package:rest_dashboard/presentation/widgets/add_new_item_card.dart';
import 'package:rest_dashboard/presentation/widgets/menu_items_section.dart';

class MenuManagementScreen extends StatefulWidget {
  final bool showBottomNav;

  const MenuManagementScreen({super.key, this.showBottomNav = true});

  @override
  State<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  String? _selectedImagePath;
  final List<String> _categories = ["Burger", "Pizza", "Dessert", "Drink"];
  bool _isLoading = false;
  String? _uploadedImageUrl;

  @override
  void dispose() {
    _itemNameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // void _addToMenu() {
  //   if (_formKey.currentState!.validate()) {
  //     final newItem = MenuItem(
  //       name: _itemNameController.text.trim(),
  //       category: _selectedCategory!,
  //       price: double.parse(_priceController.text.trim()),
  //       description: _descriptionController.text.trim(),
  //       imageUrl: _selectedImagePath ?? "", //will be edited
  //     );

  //     setState(() {
  //       MenuService.addMenuItem(
  //         name: newItem.name,
  //         description: newItem.description,
  //         category: newItem.category,
  //         price: newItem.price,
  //       );
  //     });

  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('Item added to menu')));

  //     _itemNameController.clear();
  //     _priceController.clear();
  //     _descriptionController.clear();
  //     setState(() {
  //       _selectedCategory = null;
  //       _selectedImagePath = null;
  //     });
  //   }
  // }

  // void _addToMenu() async {
  //   if (_formKey.currentState!.validate()) {
  //     final imageFile = _selectedImagePath != null
  //         ? File(_selectedImagePath!)
  //         : null;

  //     await MenuService.addMenuItem(
  //       name: _itemNameController.text.trim(),
  //       description: _descriptionController.text.trim(),
  //       category: _selectedCategory!,
  //       price: double.parse(_priceController.text.trim()),
  //       imageFile: imageFile, // ✅ Cloudinary upload here
  //     );

  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('Item added to menu')));

  //     _itemNameController.clear();
  //     _priceController.clear();
  //     _descriptionController.clear();

  //     setState(() {
  //       _selectedCategory = null;
  //       _selectedImagePath = null;
  //     });
  //   }
  // }
  void _addToMenu() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await MenuService.addMenuItem(
        name: _itemNameController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory!,
        price: double.parse(_priceController.text.trim()),
        imageUrl: _uploadedImageUrl,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Item added to menu')));

      _itemNameController.clear();
      _priceController.clear();
      _descriptionController.clear();
      _selectedCategory = null;
      _selectedImagePath = null;
      _uploadedImageUrl = null;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }

    setState(() => _isLoading = false);
  }

  void _deleteMenuItem(String id) async {
    await MenuService.deleteMenuItem(id);
    setState(() {});
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Item removed from menu')));
  }

  void _onCategoryChanged(String? category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onImageSelected(String? imagePath) {
    setState(() {
      _selectedImagePath = imagePath;
    });
  }

  void _onImageUploaded(String? url) {
    setState(() {
      print("Parent received URL = $url");
      _uploadedImageUrl = url; // 🔥 KEEP REAL URL FROM CLOUDINARY
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: MenuService.getMenuItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading menu'));
        }

        final data = snapshot.data ?? [];
        if (data.isEmpty) return Center(child: Text("No menu items"));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              AddNewItemCard(
                formKey: _formKey,
                itemNameController: _itemNameController,
                priceController: _priceController,
                descriptionController: _descriptionController,
                categories: _categories,
              ),
              const SizedBox(height: 24),
              MenuItemsSection(menuItems: data, onDeleteItem: _deleteMenuItem),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Menu Management',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Add and manage your menu items',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
