import 'package:flutter/material.dart';

class CreateOfferCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController promoCodeController;
  final TextEditingController discountController;
  final TextEditingController validFromController;
  final TextEditingController validToController;
  final String? selectedCategory;
  final List<String> categories;
  final Function(String?) onCategoryChanged;
  final VoidCallback onValidFromTap;
  final VoidCallback onValidToTap;
  final VoidCallback onCreateOffer;

  const CreateOfferCard({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.promoCodeController,
    required this.discountController,
    required this.validFromController,
    required this.validToController,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
    required this.onValidFromTap,
    required this.onValidToTap,
    required this.onCreateOffer,
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
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create New Offer',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            _buildTitleField(),
            const SizedBox(height: 16),
            // _buildPromoCodeField(),
            // const SizedBox(height: 16),
            _buildCategoryDropdown(),
            const SizedBox(height: 16),
            _buildDiscountField(),
            const SizedBox(height: 16),
            _buildValidFromField(),
            const SizedBox(height: 16),
            _buildValidToField(),
            const SizedBox(height: 20),
            _buildPreview(),
            const SizedBox(height: 24),
            _buildCreateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: titleController,
      decoration: InputDecoration(
        labelText: 'Offer Title',
        hintText: 'e.g., Weekend Special',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF9800), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter offer title';
        }
        return null;
      },
    );
  }

  // Widget _buildPromoCodeField() {
  //   return TextFormField(
  //     controller: promoCodeController,
  //     textCapitalization: TextCapitalization.characters,
  //     decoration: InputDecoration(
  //       labelText: 'Promo Code',
  //       hintText: 'e.g., WEEKEND25',
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: const BorderSide(color: Colors.grey),
  //       ),
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: const BorderSide(color: Colors.grey),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: const BorderSide(color: Color(0xFFFF9800), width: 2),
  //       ),
  //       contentPadding: const EdgeInsets.symmetric(
  //         horizontal: 16,
  //         vertical: 16,
  //       ),
  //     ),
  //     validator: (value) {
  //       if (value == null || value.isEmpty) {
  //         return 'Please enter promo code';
  //       }
  //       return null;
  //     },
  //   );
  // }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      decoration: InputDecoration(
        // labelText: 'Category',
        hintText: 'Select category',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF9800), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      ),
      items: categories.map((String category) {
        return DropdownMenuItem<String>(value: category, child: Text(category));
      }).toList(),
      onChanged: onCategoryChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a category';
        }
        return null;
      },
    );
  }

  Widget _buildDiscountField() {
    return TextFormField(
      controller: discountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Discount (%)',
        hintText: 'e.g., 25',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF9800), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter discount';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid discount';
        }
        final discount = double.parse(value);
        if (discount < 0 || discount > 100) {
          return 'Discount must be between 0 and 100';
        }
        return null;
      },
    );
  }

  Widget _buildValidFromField() {
    return TextFormField(
      controller: validFromController,
      readOnly: true,
      onTap: onValidFromTap,
      decoration: InputDecoration(
        labelText: 'Valid From',
        hintText: 'dd/mm/yyyy',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF9800), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select valid from date';
        }
        return null;
      },
    );
  }

  Widget _buildValidToField() {
    return TextFormField(
      controller: validToController,
      readOnly: true,
      onTap: onValidToTap,
      decoration: InputDecoration(
        labelText: 'Valid To',
        hintText: 'dd/mm/yyyy',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF9800), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select valid to date';
        }
        return null;
      },
    );
  }

  Widget _buildPreview() {
    final discount = discountController.text.isEmpty
        ? '0'
        : discountController.text;
    final title = titleController.text.isEmpty
        ? 'Offer Title'
        : titleController.text;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFF9800).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Preview',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Text(
            '$discount% OFF',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF9800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onCreateOffer,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF9800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_offer, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Create Offer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
