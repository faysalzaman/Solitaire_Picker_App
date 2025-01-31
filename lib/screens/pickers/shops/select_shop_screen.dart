// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solitaire_picker/constants/constant.dart';
import 'package:solitaire_picker/cubit/journey/journey_cubit.dart';
import 'package:solitaire_picker/cubit/journey/journey_state.dart';
import 'package:solitaire_picker/cubit/store/store_cubit.dart';
import 'package:solitaire_picker/cubit/store/store_state.dart';
import 'package:solitaire_picker/model/active_picker_model.dart';
import 'package:solitaire_picker/screens/pickers/shops/home_delivery_gate_delivery.dart';
import 'package:solitaire_picker/screens/pickers/shops/shop_detail_screen.dart';
import 'package:solitaire_picker/utils/app_navigator.dart';
import 'package:solitaire_picker/widgets/brand_card.dart';
import 'package:solitaire_picker/widgets/placeholder_brand_card.dart';

import 'package:solitaire_picker/widgets/search_store_by_nfc_dialog.dart';

class SelectShopScreen extends StatefulWidget {
  const SelectShopScreen({
    super.key,
    required this.activePickerModel,
    required this.customerId,
    required this.journeyId,
  });

  final ActivePickerModel activePickerModel;
  final String customerId;
  final String journeyId;

  @override
  State<SelectShopScreen> createState() => _SelectShopScreenState();
}

class _SelectShopScreenState extends State<SelectShopScreen> {
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

  String scanType = 'QR';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<StoreCubit>().getStores('', page, limit);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Finish Shopping',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.purpleColor,
              ),
            ),
            content: const Text(
              'Are you sure you want to finish shopping?',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.purpleColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                  context.read<JourneyCubit>().endJourney(widget.journeyId);
                },
                child: const Text(
                  'Exit',
                  style: TextStyle(
                    color: AppColors.errorColor,
                  ),
                ),
              ),
            ],
          ),
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<StoreCubit, StoreState>(
            listener: (context, state) {
              if (state is JourneyEnded) {
                AppNavigator.push(
                  context,
                  DeliveryOptionScreen(),
                );
              }
            },
            builder: (context, state) {
              return Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: BlocConsumer<JourneyCubit, JourneyState>(
                    listener: (context, state) {},
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
                                          icon:
                                              const Icon(Icons.qr_code_scanner),
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
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  content: TextField(
                                                    controller:
                                                        _qrCodeController,
                                                    autofocus: true,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: 'Enter QR Code',
                                                      hintStyle: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    onSubmitted: (value) {
                                                      setState(() {
                                                        scanType = 'QR';
                                                      });
                                                      _qrCodeController.text =
                                                          value;
                                                      context
                                                          .read<StoreCubit>()
                                                          .getStoreByQRCode(
                                                              value);
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
                                            setState(() {
                                              scanType = 'NFC';
                                            });
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

                              // Brand grid and Load More button
                              Expanded(
                                child: state is StoreLoading
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
                                    : Column(
                                        children: [
                                          Expanded(
                                            child: GridView.builder(
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
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          backgroundColor:
                                                              Colors.white,
                                                          title: const Text(
                                                            'Confirm Shop Selection',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                            ),
                                                          ),
                                                          content: Text(
                                                            'Do you want to do shopping in ${context.read<StoreCubit>().stores[index].storeName}?',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context); // Close dialog
                                                              },
                                                              child: const Text(
                                                                'Cancel',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ),
                                                            FilledButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                                AppNavigator
                                                                    .push(
                                                                  context,
                                                                  ShopDetailsScreen(
                                                                    journeyId:
                                                                        widget
                                                                            .journeyId,
                                                                    store: context
                                                                        .read<
                                                                            StoreCubit>()
                                                                        .stores[index],
                                                                    customerId:
                                                                        widget
                                                                            .customerId,
                                                                    scanType:
                                                                        scanType,
                                                                  ),
                                                                );
                                                              },
                                                              child: const Text(
                                                                'Confirm',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  store: context
                                                      .read<StoreCubit>()
                                                      .stores[index],
                                                );
                                              },
                                              itemCount: context
                                                  .read<StoreCubit>()
                                                  .stores
                                                  .length,
                                            ),
                                          ),
                                          if (context
                                                      .read<StoreCubit>()
                                                      .stores
                                                      .length >=
                                                  limit &&
                                              state is StoreLoaded)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 16.0),
                                              child: TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    page++;
                                                  });
                                                  context
                                                      .read<StoreCubit>()
                                                      .getStores(
                                                          _storeController.text,
                                                          page,
                                                          limit);
                                                },
                                                child: const Text('Load More'),
                                              ),
                                            ),
                                        ],
                                      ),
                              ),

                              const Spacer(),
                              // Finish Shopping button
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: () {
                                    context
                                        .read<JourneyCubit>()
                                        .endJourney(widget.journeyId);
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Finish Shopping',
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
            },
          ),
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
