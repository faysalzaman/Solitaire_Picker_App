import 'package:flutter/material.dart';
import 'package:solitaire_picker/constants/constant.dart';
import 'package:solitaire_picker/model/store_model.dart';
import 'package:solitaire_picker/widgets/brand_card.dart';

class PickerTransactionScreen extends StatefulWidget {
  const PickerTransactionScreen({super.key});

  @override
  State<PickerTransactionScreen> createState() =>
      _PickerTransactionScreenState();
}

class _PickerTransactionScreenState extends State<PickerTransactionScreen> {
  final TextEditingController _storeController = TextEditingController();

  @override
  void dispose() {
    _storeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Picker Transaction',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Store number input field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _storeController,
                  decoration: InputDecoration(
                    hintText: 'Enter Store #',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.qr_code_scanner),
                          onPressed: () {
                            // Handle QR code scanning
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            // Handle copy functionality
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Customer info card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mr.Hasnain Ahmad',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '+966 52 762 1329',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Brand grid
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  BrandCard(
                    logo: 'assets/brands/louis_vuitton.png',
                    name: 'Louis Vuitton',
                    onTap: () {},
                    store: StoreModel(
                      id: '1',
                      storeName: 'Louis Vuitton',
                      logo: 'assets/brands/louis_vuitton.png',
                    ),
                  ),
                  BrandCard(
                    logo: 'assets/brands/balenciaga.png',
                    name: 'Balenciaga',
                    onTap: () {},
                    store: StoreModel(
                      id: '2',
                      storeName: 'Balenciaga',
                      logo: 'assets/brands/balenciaga.png',
                    ),
                  ),
                  BrandCard(
                    logo: 'assets/brands/chanel.png',
                    name: 'Chanel',
                    onTap: () {},
                    store: StoreModel(
                      id: '3',
                      storeName: 'Chanel',
                      logo: 'assets/brands/chanel.png',
                    ),
                  ),
                  BrandCard(
                    logo: 'assets/brands/chloe.png',
                    name: 'Chloe',
                    onTap: () {},
                    store: StoreModel(
                      id: '4',
                      storeName: 'Chloe',
                      logo: 'assets/brands/chloe.png',
                    ),
                  ),
                  BrandCard(
                    logo: 'assets/brands/calvin_klein.png',
                    name: 'Calvin Klein',
                    onTap: () {},
                    store: StoreModel(
                      id: '5',
                      storeName: 'Calvin Klein',
                      logo: 'assets/brands/calvin_klein.png',
                    ),
                  ),
                  BrandCard(
                    logo: 'assets/brands/celine.png',
                    name: 'Celine',
                    onTap: () {},
                    store: StoreModel(
                      id: '6',
                      storeName: 'Celine',
                      logo: 'assets/brands/celine.png',
                    ),
                  ),
                  BrandCard(
                    logo: 'assets/brands/jon_vinnys.png',
                    name: 'JON&VINNYS',
                    onTap: () {},
                    store: StoreModel(
                      id: '7',
                      storeName: 'JON&VINNYS',
                      logo: 'assets/brands/jon_vinnys.png',
                    ),
                  ),
                  BrandCard(
                    logo: 'assets/brands/bateel.png',
                    name: 'BATEEL',
                    onTap: () {},
                    store: StoreModel(
                      id: '8',
                      storeName: 'BATEEL',
                      logo: 'assets/brands/bateel.png',
                    ),
                  ),
                ],
              ),

              const Spacer(),
              // Continue button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle continue action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purpleColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
