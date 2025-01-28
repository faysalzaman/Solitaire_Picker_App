// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:solitaire_picker/constants/constant.dart';
import 'package:solitaire_picker/cubit/picker_profile/profile_cubit.dart';

class NFCEnableDialog extends StatefulWidget {
  const NFCEnableDialog({
    super.key,
    this.serialNumber,
    required this.nfcValue,
    required this.profileCubit,
  });

  final String? serialNumber;
  final bool nfcValue;
  final ProfileCubit profileCubit;

  @override
  State<NFCEnableDialog> createState() => _NFCEnableDialogState();
}

class _NFCEnableDialogState extends State<NFCEnableDialog> {
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _startNFCScan();
  }

  Future<void> _startNFCScan() async {
    setState(() => _isScanning = true);

    try {
      bool isAvailable = await NfcManager.instance.isAvailable();

      if (!isAvailable) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('NFC is not available on this device')),
          );
        }
        return;
      }

      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            final nfcData = tag.data;

            // Extract serial number from NFC data
            String? serialNumber;

            // For ISO 14443-4 tags (as shown in your image)
            if (nfcData['iso14443-4'] != null) {
              // The identifier/serial number is usually in the historical bytes
              final identifier = nfcData['iso14443-4']['identifier'];
              if (identifier != null) {
                // Convert bytes to hex string and format it
                serialNumber = identifier
                    .map((e) => e.toRadixString(16).padLeft(2, '0'))
                    .join(':')
                    .toUpperCase();
              }
            }

            // Alternative method to get identifier (works with most NFC tags)
            if (serialNumber == null && nfcData['nfca'] != null) {
              final identifier = nfcData['nfca']['identifier'];
              if (identifier != null) {
                serialNumber = identifier
                    .map((e) => e.toRadixString(16).padLeft(2, '0'))
                    .join(':')
                    .toUpperCase();
              }
            }

            if (mounted) {
              Navigator.pop(context);
              print('serialNumber: $serialNumber');
              widget.profileCubit.enableNfc(true, serialNumber!);
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error reading NFC: $e')),
              );
            }
          }
        },
      );
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ready to Scan?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.purpleColor,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 120,
              height: 120,
              child: Image.asset('assets/nfc.png'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Hold or Tap your phone\nnear object to scan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
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
    );
  }
}
