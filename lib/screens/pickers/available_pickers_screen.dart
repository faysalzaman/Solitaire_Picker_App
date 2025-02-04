// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solitaire_picker/constants/constant.dart';
import 'package:solitaire_picker/cubit/picker/picker_cubit.dart';
import 'package:solitaire_picker/cubit/picker/picker_state.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';
import 'package:solitaire_picker/screens/pickers/customer_tracking_screen.dart';
import 'package:solitaire_picker/utils/app_loading.dart';
import 'package:solitaire_picker/utils/app_navigator.dart';

class AvailablePickersScreen extends StatefulWidget {
  const AvailablePickersScreen({super.key});

  @override
  State<AvailablePickersScreen> createState() => _AvailablePickersScreenState();
}

class _AvailablePickersScreenState extends State<AvailablePickersScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _refreshTimer;
  int page = 1;
  int limit = 10;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<PickerCubit>().getPickers(page, limit);
    _scrollController.addListener(_onScroll);

    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          page = 1;
          context.read<PickerCubit>().pickers.clear();
          context.read<PickerCubit>().getPickers(page, limit);
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshTimer?.cancel();

    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.95 &&
        !isLoading &&
        context.read<PickerCubit>().hasMoreData) {
      setState(() {
        isLoading = true;
      });
      page++;
      context.read<PickerCubit>().getPickers(page, limit);
    }
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              children: List.generate(
                5,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 90,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Confirmation dialog to exit
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Are you sure you want to exit?',
              style: TextStyle(
                color: AppColors.purpleColor,
                fontSize: 12,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.purpleColor,
                    fontSize: 12,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Exit',
                  style: TextStyle(
                    color: AppColors.purpleColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocConsumer<PickerCubit, PickerState>(
            listener: (context, state) {
              print('State changed: $state');
              if (state is PickerSuccessState) {
                setState(() {
                  isLoading = false;
                });
              }
              if (state is PickerErrorState) {
                setState(() {
                  isLoading = false;
                  page--;
                });
              }
              if (state is AcceptDeclinePickerSuccessState) {
                setState(() {
                  isLoading = false;
                });
                context.read<PickerCubit>().getPickers(page, limit);
              }
              if (state is AcceptDeclinePickerErrorState) {
                setState(() {
                  isLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Failed to accept/decline picker')),
                );
              }
            },
            builder: (context, state) {
              final pickers = context.read<PickerCubit>().pickers;

              return Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Refresh Button Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Available Requests',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.purpleColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.refresh,
                                    color: AppColors.purpleColor),
                                onPressed: () {
                                  setState(() {
                                    page = 1;
                                    context.read<PickerCubit>().pickers.clear();
                                    context
                                        .read<PickerCubit>()
                                        .getPickers(page, limit);
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Show shimmer loading when in initial or loading state
                          if (state is PickerInitialState ||
                              (state is PickerLoadingState && pickers.isEmpty))
                            _buildLoadingShimmer()
                          else
                            ...pickers
                                .map((picker) => Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildDetailRow(
                                              'Status', '${picker.status}'),
                                          _buildDetailRow('Customer Name',
                                              '${picker.customer?.name}'),
                                          _buildDetailRow('Phone',
                                              '${picker.customer?.phone}'),
                                          _buildDetailRow(
                                              'Location', '${picker.location}'),
                                          _buildDetailRow('Coordinates',
                                              '${picker.customerLat}, ${picker.customerLng}'),
                                          _buildDetailRow('Requested At',
                                              '${picker.createdAt}'),

                                          const SizedBox(height: 16),
                                          // Action Buttons

                                          if (picker.status == 'ACCEPTED')
                                            Center(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${picker.status}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  FilledButton(
                                                    onPressed: () {
                                                      AppNavigator.push(
                                                        context,
                                                        CustomerTrackingScreen(
                                                          activePickerModel:
                                                              picker,
                                                          customerId:
                                                              picker.id ?? "",
                                                        ),
                                                      );
                                                    },
                                                    child: const Text(
                                                        'Track Customer'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          Visibility(
                                            visible:
                                                picker.status != 'ACCEPTED',
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                FilledButton(
                                                  onPressed: () {
                                                    // Handle accept action
                                                    context
                                                        .read<PickerCubit>()
                                                        .acceptDeclinePicker(
                                                          picker.id.toString(),
                                                          true,
                                                        );
                                                  },
                                                  style: FilledButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                    foregroundColor:
                                                        Colors.white,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 32),
                                                  ),
                                                  child: const Text('Accept'),
                                                ),
                                                FilledButton(
                                                  onPressed: () {
                                                    // Handle reject action
                                                    context
                                                        .read<PickerCubit>()
                                                        .acceptDeclinePicker(
                                                          picker.id.toString(),
                                                          false,
                                                        );
                                                  },
                                                  style: FilledButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor:
                                                        Colors.white,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 32),
                                                  ),
                                                  child: const Text('Reject'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          // Loading indicator for pagination
                          if (isLoading)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: AppLoading(
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 90,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.purpleColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.purpleColor.withOpacity(0.8),
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
