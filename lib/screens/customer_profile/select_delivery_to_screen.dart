// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:solitaire_picker/constants/constant.dart';
import 'package:solitaire_picker/screens/customer_profile/select_mall_gate_screen.dart';
import 'package:solitaire_picker/utils/app_navigator.dart';
import 'package:solitaire_picker/widgets/service_card.dart';

class SelectDeliveryToScreen extends StatelessWidget {
  const SelectDeliveryToScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                      fontSize: 16,
                      color: AppColors.purpleColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Services Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ServiceCard(
                  title: 'Home Delivery',
                  imagePath: 'assets/home_delivery.png',
                  onTap: () {},
                ),
                const SizedBox(width: 20),
                ServiceCard(
                  title: 'Mall Gates',
                  imagePath: 'assets/mall_gates.png',
                  onTap: () {
                    AppNavigator.push(context, const SelectMallGateScreen());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
