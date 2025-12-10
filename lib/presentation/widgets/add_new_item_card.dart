// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';

// class AddNewItemCard extends StatefulWidget {
//   final GlobalKey<FormState> formKey;
//   final TextEditingController itemNameController;
//   final TextEditingController priceController;
//   final TextEditingController descriptionController;
//   final String? selectedCategory;
//   final List<String> categories;
//   final Function(String?) onCategoryChanged;
//   final VoidCallback onAddToMenu;
//   final String? selectedImagePath;
//   final Function(String?) onImageSelected;
//   final Function(String?) onImageUploaded;

//   const AddNewItemCard({
//     super.key,
//     required this.formKey,
//     required this.itemNameController,
//     required this.priceController,
//     required this.descriptionController,
//     required this.selectedCategory,
//     required this.categories,
//     required this.onCategoryChanged,
//     required this.onAddToMenu,
//     this.selectedImagePath,
//     required this.onImageSelected,
//     required this.onImageUploaded,
//   });

//   @override
//   State<AddNewItemCard> createState() => _AddNewItemCardState();
// }

// class _AddNewItemCardState extends State<AddNewItemCard> {
//   File? _imageFile;
//   String? _imageUrl;

//   final picker = ImagePicker();

//   // Future<void> pickImage() async {
//   //   final picked = await picker.pickImage(source: ImageSource.gallery);

//   //   if (picked != null) {
//   //     widget.onImageSelected(picked.path);

//   //     setState(() {
//   //       _imageFile = File(picked.path);
//   //     });

//   //     await _uploadImage(); // upload immediately after picking
//   //   }
//   // }

//   Future<void> pickImage() async {
//     final picked = await picker.pickImage(source: ImageSource.gallery);

//     if (picked != null) {
//       widget.onImageSelected(picked.path);

//       if (!mounted) return;

//       setState(() {
//         _imageFile = File(picked.path);
//       });

//       await _uploadImage();
//     }
//   }

//   // Future<void> _uploadImage() async {
//   //   if (_imageFile == null) return;

//   //   final cloudName = "dwhyg24zo";
//   //   final uploadPreset = "ml_default";

//   //   final url = Uri.parse(
//   //     "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
//   //   );

//   //   final request = http.MultipartRequest("POST", url)
//   //     ..fields["upload_preset"] = uploadPreset
//   //     ..files.add(await http.MultipartFile.fromPath("file", _imageFile!.path));

//   //   final response = await request.send();

//   //   if (response.statusCode == 200) {
//   //     final responseData = await response.stream.bytesToString();
//   //     final jsonMap = jsonDecode(responseData);
//   //     final uploadedUrl = jsonMap["secure_url"];

//   //     setState(() {
//   //       _imageUrl = jsonMap["secure_url"]; // IMPORTANT
//   //     });
//   //     widget.onImageUploaded(uploadedUrl); // 🔥 SEND URL TO PARENT

//   //     print("Uploaded URL: $_imageUrl");
//   //   } else {
//   //     print("Upload failed (${response.statusCode})");
//   //   }
//   // }

//   Future<void> _uploadImage() async {
//     if (_imageFile == null) return;

//     final cloudName = "dwhyg24zo";
//     final uploadPreset = "ml_default";

//     final url = Uri.parse(
//       "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
//     );

//     final request = http.MultipartRequest("POST", url)
//       ..fields["upload_preset"] = uploadPreset
//       ..files.add(await http.MultipartFile.fromPath("file", _imageFile!.path));

//     final response = await request.send();

//     if (response.statusCode == 200) {
//       final responseData = await response.stream.bytesToString();
//       final jsonMap = jsonDecode(responseData);
//       final uploadedUrl = jsonMap["secure_url"];

//       if (!mounted) return; // ← ADD THIS

//       setState(() {
//         _imageUrl = uploadedUrl;
//       });

//       print("Uploaded URL = $uploadedUrl"); // Cloudinary return
//       widget.onImageUploaded(uploadedUrl);
//       print("Callback called"); // Confirm callback
//     }
//   }

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
//       child: Form(
//         key: widget.formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Add New Item',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 20),
//             _buildImagePicker(),
//             const SizedBox(height: 16),
//             _buildItemNameField(),
//             const SizedBox(height: 16),
//             _buildCategoryDropdown(),
//             const SizedBox(height: 16),
//             _buildPriceField(),
//             const SizedBox(height: 16),
//             _buildDescriptionField(),
//             const SizedBox(height: 24),
//             _buildAddButton(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildItemNameField() {
//     return TextFormField(
//       controller: widget.itemNameController,
//       decoration: InputDecoration(
//         labelText: 'Item Name',
//         hintText: 'e.g., Classic Burger',
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.grey),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.grey),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 16,
//         ),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter item name';
//         }
//         return null;
//       },
//     );
//   }

//   Widget _buildCategoryDropdown() {
//     return DropdownButtonFormField<String>(
//       value: widget.selectedCategory,
//       decoration: InputDecoration(
//         // labelText: 'Category',
//         hintText: 'Select category',
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.grey),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.grey),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 16,
//         ),
//         suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
//       ),
//       items: widget.categories.map((String category) {
//         return DropdownMenuItem<String>(value: category, child: Text(category));
//       }).toList(),
//       onChanged: widget.onCategoryChanged,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please select a category';
//         }
//         return null;
//       },
//     );
//   }

//   Widget _buildPriceField() {
//     return TextFormField(
//       controller: widget.priceController,
//       keyboardType: TextInputType.number,
//       decoration: InputDecoration(
//         labelText: 'Price (\$)',
//         hintText: 'e.g., 15.99',
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.grey),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.grey),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 16,
//         ),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter price';
//         }
//         if (double.tryParse(value) == null) {
//           return 'Please enter a valid price';
//         }
//         return null;
//       },
//     );
//   }

//   Widget _buildDescriptionField() {
//     return TextFormField(
//       controller: widget.descriptionController,
//       maxLines: 3,
//       decoration: InputDecoration(
//         labelText: 'Description',
//         hintText: 'Brief description of the item',
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.grey),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.grey),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 16,
//         ),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter description';
//         }
//         return null;
//       },
//     );
//   }

//   Widget _buildImagePicker() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Item Image',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Builder(
//           builder: (context) => GestureDetector(
//             onTap: () => _showImageSourceDialog(context),
//             child: Container(
//               height: 150,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: widget.selectedImagePath != null
//                       ? const Color(0xFF4CAF50)
//                       : Colors.grey[300]!,
//                   width: widget.selectedImagePath != null ? 2 : 1,
//                 ),
//               ),
//               child: widget.selectedImagePath != null
//                   ? Stack(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: Image.file(
//                             File(widget.selectedImagePath!),
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                             height: double.infinity,
//                           ),
//                         ),
//                         Positioned(
//                           top: 8,
//                           right: 8,
//                           child: Container(
//                             decoration: const BoxDecoration(
//                               color: Colors.red,
//                               shape: BoxShape.circle,
//                             ),
//                             child: IconButton(
//                               icon: const Icon(
//                                 Icons.close,
//                                 color: Colors.white,
//                                 size: 20,
//                               ),
//                               onPressed: () => widget.onImageSelected(null),
//                               padding: EdgeInsets.zero,
//                               constraints: const BoxConstraints(),
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                   : Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.add_photo_alternate_outlined,
//                           size: 48,
//                           color: Colors.grey[400],
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Tap to add image',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void _showImageSourceDialog(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text('Choose from Gallery'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   pickImage();
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.camera_alt),
//                 title: const Text('Take a Photo'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   pickImage();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildAddButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 56,
//       child: ElevatedButton(
//         onPressed: widget.onAddToMenu,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF4CAF50),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 0,
//         ),
//         child: const Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.restaurant_menu, color: Colors.white, size: 20),
//             SizedBox(width: 8),
//             Text(
//               'Add to Menu',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:rest_dashboard/data/services/menu_services.dart';

class AddNewItemCard extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController itemNameController;
  final TextEditingController priceController;
  final TextEditingController descriptionController;
  final List<String> categories;

  const AddNewItemCard({
    super.key,
    required this.formKey,
    required this.itemNameController,
    required this.priceController,
    required this.descriptionController,
    required this.categories,
  });

  @override
  State<AddNewItemCard> createState() => _AddNewItemCardState();
}

class _AddNewItemCardState extends State<AddNewItemCard> {
  File? _imageFile;
  String? _imageUrl;
  String? _selectedCategory;

  final ImagePicker picker = ImagePicker();

  // ✅ PICK IMAGE FROM GALLERY
  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });

      await _uploadImage();
    }
  }

  // ✅ UPLOAD TO CLOUDINARY
  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    final cloudName = "dwhyg24zo";
    final uploadPreset = "ml_default";

    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final request = http.MultipartRequest("POST", url)
      ..fields["upload_preset"] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath("file", _imageFile!.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonMap = jsonDecode(responseData);

      setState(() {
        _imageUrl = jsonMap["secure_url"]; // ✅ CLOUDINARY URL STORED
      });

      print("Uploaded URL = $_imageUrl");
    } else {
      print("Cloudinary upload failed");
    }
  }

  // ✅ SAVE DIRECTLY TO FIRESTORE
  Future<void> _saveItem() async {
    if (!widget.formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a category")));
      return;
    }

    await MenuService.addMenuItem(
      name: widget.itemNameController.text,
      description: widget.descriptionController.text,
      category: _selectedCategory!,
      price: double.parse(widget.priceController.text),
      imageUrl: _imageUrl, // ✅ NOT NULL ANYMORE
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Item added successfully")));

    // ✅ RESET FORM
    widget.itemNameController.clear();
    widget.priceController.clear();
    widget.descriptionController.clear();

    setState(() {
      _imageFile = null;
      _imageUrl = null;
      _selectedCategory = null;
    });
  }

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
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Item',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildImagePicker(),
            const SizedBox(height: 16),
            _buildItemNameField(),
            const SizedBox(height: 16),
            _buildCategoryDropdown(),
            const SizedBox(height: 16),
            _buildPriceField(),
            const SizedBox(height: 16),
            _buildDescriptionField(),
            const SizedBox(height: 24),
            _buildAddButton(),
          ],
        ),
      ),
    );
  }

  // ✅ IMAGE PICKER UI
  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: pickImage,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _imageFile != null ? Colors.green : Colors.grey,
          ),
        ),
        child: _imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _imageFile!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate_outlined, size: 50),
                    SizedBox(height: 8),
                    Text("Tap to select image"),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildItemNameField() {
    return TextFormField(
      controller: widget.itemNameController,
      decoration: const InputDecoration(labelText: 'Item Name'),
      validator: (value) =>
          value == null || value.isEmpty ? "Enter item name" : null,
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      items: widget.categories
          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
        });
      },
      validator: (value) => value == null ? "Please select a category" : null,
      decoration: const InputDecoration(labelText: 'Category'),
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      controller: widget.priceController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(labelText: 'Price'),
      validator: (value) =>
          value == null || value.isEmpty ? "Enter price" : null,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: widget.descriptionController,
      maxLines: 3,
      decoration: const InputDecoration(labelText: 'Description'),
      validator: (value) =>
          value == null || value.isEmpty ? "Enter description" : null,
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _saveItem, // ✅ DIRECT FIRESTORE SAVE
        child: const Text("Add to Menu"),
      ),
    );
  }
}
