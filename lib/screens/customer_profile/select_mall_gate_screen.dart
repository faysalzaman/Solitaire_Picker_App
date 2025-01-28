// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:solitaire_picker/constants/constant.dart';
import 'package:solitaire_picker/widgets/service_card.dart';

class SelectMallGateScreen extends StatelessWidget {
  const SelectMallGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Back Button and Title Row
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 20),
                      onPressed: () => Navigator.pop(context),
                      color: AppColors.purpleColor,
                    ),
                    const Text(
                      'Select Delivery To',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.purpleColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Services Grid
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ...List.generate(
                    4,
                    (index) => ServiceCard(
                      title: 'Mall Gate ${index + 1}',
                      imagePath: 'assets/mall_gates.png',
                      onTap: () {
                        // Handle Request Delivery tap
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
