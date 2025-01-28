// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:solitaire_picker/constants/constant.dart';
import 'package:solitaire_picker/screens/customer_profile/select_delivery_to_screen.dart';
import 'package:solitaire_picker/screens/pickers/available_pickers_screen.dart';
import 'package:solitaire_picker/utils/app_navigator.dart';
import 'package:solitaire_picker/widgets/service_card.dart';

class SelectServicesScreen extends StatelessWidget {
  const SelectServicesScreen({super.key});

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
                    'Select Services',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ServiceCard(
                  title: 'Request Picker',
                  imagePath: 'assets/request_picker.png',
                  onTap: () {
                    AppNavigator.push(context, const AvailablePickersScreen());
                  },
                ),
                const SizedBox(width: 20),
                ServiceCard(
                  title: 'Request Delivery',
                  imagePath: 'assets/request_delivery.png',
                  onTap: () {
                    AppNavigator.push(context, const SelectDeliveryToScreen());
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
