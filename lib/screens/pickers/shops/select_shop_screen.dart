// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solitaire_picker/constants/constant.dart';
import 'package:solitaire_picker/cubit/store/store_cubit.dart';
import 'package:solitaire_picker/cubit/store/store_state.dart';
import 'package:solitaire_picker/model/active_picker_model.dart';
import 'package:solitaire_picker/screens/pickers/shops/shop_detail_screen.dart';
import 'package:solitaire_picker/utils/app_navigator.dart';
import 'package:solitaire_picker/widgets/brand_card.dart';
import 'package:solitaire_picker/widgets/placeholder_brand_card.dart';

import 'package:solitaire_picker/widgets/search_store_by_nfc_dialog.dart';

class PickerTransactionScreen extends StatefulWidget {
  const PickerTransactionScreen({super.key, required this.activePickerModel});

  final ActivePickerModel activePickerModel;

  @override
  State<PickerTransactionScreen> createState() =>
      _PickerTransactionScreenState();
}

class _PickerTransactionScreenState extends State<PickerTransactionScreen> {
  final TextEditingController _storeController = TextEditingController();
  final TextEditingController _qrCodeController = TextEditingController();

  @override
  void dispose() {
    _storeController.dispose();
    _qrCodeController.dispose();
    super.dispose();
  }

  int page = 1;
  int limit = 10;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<StoreCubit>().getStores('', page, limit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<StoreCubit, StoreState>(
          listener: (context, state) {
            print(state);
          },
          builder: (context, state) {
            return GestureDetector(
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
                        onChanged: (value) {
                          setState(() {
                            page = 1;
                            limit = 10;
                          });
                          context
                              .read<StoreCubit>()
                              .getStores(value, page, limit);
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Store Name',
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
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        title: const Text(
                                          'Scan QR Code',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        content: TextField(
                                          controller: _qrCodeController,
                                          autofocus: true,
                                          decoration: const InputDecoration(
                                            hintText: 'Enter QR Code',
                                            hintStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          onSubmitted: (value) {
                                            _qrCodeController.text = value;
                                            context
                                                .read<StoreCubit>()
                                                .getStoreByQRCode(value);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.nfc),
                                onPressed: () {
                                  // Handle copy functionality
                                  _searchByNfc();
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
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${widget.activePickerModel.customer?.name}',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${widget.activePickerModel.customer?.phone}',
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
                    state is StoreLoading
                        ? GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1.5,
                            ),
                            shrinkWrap: true,
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return const PlaceholderBrandCard();
                            },
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1.5,
                            ),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return BrandCard(
                                logo: context
                                        .read<StoreCubit>()
                                        .stores[index]
                                        .logo ??
                                    '',
                                name: context
                                        .read<StoreCubit>()
                                        .stores[index]
                                        .storeName ??
                                    '',
                                onTap: () {
                                  // Handle tap
                                  AppNavigator.push(
                                    context,
                                    ShopDetailsScreen(
                                      store: context
                                          .read<StoreCubit>()
                                          .stores[index],
                                    ),
                                  );
                                },
                                store: context.read<StoreCubit>().stores[index],
                              );
                            },
                            itemCount: context.read<StoreCubit>().stores.length,
                          ),

                    const Spacer(),
                    // Continue button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          // Handle continue action
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _searchByNfc() async {
    // Show confirmation dialog before enabling

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SearchStoreByNFCDialog(
            storeCubit: context.read<StoreCubit>(),
          );
        },
      );
    }
  }
}
