// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:solitaire_picker/constants/constant.dart';
import 'package:solitaire_picker/model/store_model.dart';
import 'dart:async';

class ShopDetailsScreen extends StatefulWidget {
  const ShopDetailsScreen({super.key, required this.store});

  final StoreModel store;

  @override
  State<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen> {
  late Timer _timer;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    // Start the timer when screen is initialized
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration += const Duration(seconds: 1);
      });
    });
  }

  @override
  void dispose() {
    // Cancel the timer when leaving the screen
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Store Header with Image
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.store.id ?? '',
                child: Image.network(
                  widget.store.logo ?? 'https://placeholder.com/store',
                  fit: BoxFit.cover,
                ),
              ),
              title: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.store.storeName ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),

          // Store Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Store Info Card
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Address: ${widget.store.location ?? 'Address not available'}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  color: AppColors.purpleColor),
                              const SizedBox(width: 8),
                              Text(
                                "Operating Hours: ${widget.store.operatingHours ?? 'Hours not available'}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Timer Section
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Time Spent in Store',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatDuration(_duration),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.purpleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Description Section
                  Text(
                    'About ${widget.store.storeName ?? ''}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.store.description ?? 'No description available',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Additional Store Details
                  Text(
                    'Store Details',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ListTile(
                            leading: PrettyQr(
                              data: widget.store.qrCode ?? '',
                              size: 30,
                            ),
                            title: const Text('QR Code'),
                            subtitle:
                                Text(widget.store.qrCode ?? 'Not available'),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: const Text('Store QR Code'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      PrettyQr(
                                        data: widget.store.qrCode ?? '',
                                        size: 200,
                                        roundEdges: true,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(widget.store.qrCode ??
                                          'Not available'),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading:
                                const Icon(Icons.nfc, color: Colors.purple),
                            title: const Text('NFC Tag'),
                            subtitle:
                                Text(widget.store.nfcTag ?? 'Not available'),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.visibility,
                                color: Colors.green),
                            title: const Text('Visit Count'),
                            subtitle:
                                Text('${widget.store.visitCount ?? 0} visits'),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Icon(
                              widget.store.isActive ?? false
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: widget.store.isActive ?? false
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            title: const Text('Status'),
                            subtitle: Text(widget.store.isActive ?? false
                                ? 'Active'
                                : 'Inactive'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
