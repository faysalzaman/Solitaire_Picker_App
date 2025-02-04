// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solitaire_picker/constants/constant.dart';
import 'package:solitaire_picker/cubit/history/history_cubit.dart';
import 'package:solitaire_picker/cubit/history/history_state.dart';
import 'package:solitaire_picker/screens/history/store_visit_screen.dart';
import 'package:solitaire_picker/utils/app_loading.dart';
import 'package:solitaire_picker/utils/app_navigator.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int currentPage = 1;
  final int itemsPerPage = 10;
  bool isLoadingMore = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    context.read<HistoryCubit>().getHistory(
          _searchController.text, // search term
          currentPage.toString(),
          itemsPerPage.toString(),
          'COMPLETED', // status
        );
  }

  void _onSearchChanged() {
    currentPage = 1; // Reset to first page when searching
    context.read<HistoryCubit>().getHistory(
          _searchController.text,
          currentPage.toString(),
          itemsPerPage.toString(),
          'COMPLETED',
        );
  }

  Future<void> _loadMoreData() async {
    setState(() {
      isLoadingMore = true;
    });

    currentPage++;
    await context.read<HistoryCubit>().getMoreHistory(
          _searchController.text, // Updated search term
          currentPage.toString(),
          itemsPerPage.toString(),
          'COMPLETED',
        );

    setState(() {
      isLoadingMore = false;
    });
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
        body: SafeArea(
          child: BlocBuilder<HistoryCubit, HistoryState>(
            builder: (context, state) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search history...',
                              prefixIcon: const Icon(Icons.search,
                                  color: AppColors.primaryColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: AppColors.primaryColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: AppColors.primaryColor, width: 2),
                              ),
                            ),
                            onChanged: (value) => _onSearchChanged(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.refresh,
                              color: AppColors.primaryColor),
                          onPressed: _loadInitialData,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _buildHistoryContent(state),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryContent(HistoryState state) {
    if (state is HistoryLoadingState) {
      return Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: 5, // Show 5 placeholder items
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(5, (index) => _buildPlaceholderRow()),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    if (state is HistoryErrorState) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: Center(
          child: Text(
            state.message,
            style: const TextStyle(
              color: AppColors.primaryColor,
            ),
          ),
        ),
      );
    }

    if (state is HistoryLoadedState) {
      return Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: context.read<HistoryCubit>().history.length + 1,
            itemBuilder: (context, index) {
              if (index == context.read<HistoryCubit>().history.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: context.read<HistoryCubit>().hasReachedEnd
                      ? const Center(
                          child: Text(
                            'No more history',
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: isLoadingMore ? null : _loadMoreData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: isLoadingMore
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: AppLoading(
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                )
                              : const Text(
                                  'Load More',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                );
              }

              final historyItem = context.read<HistoryCubit>().history[index];

              return GestureDetector(
                onTap: () {
                  AppNavigator.push(
                    context,
                    StoreVistScreen(
                      journeyId: historyItem.id ?? '',
                    ),
                  );
                },
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                historyItem.status ?? '',
                                style: const TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow('Customer Name:',
                            historyItem.customer?.name ?? 'null'),
                        _buildInfoRow(
                            'Start Time:', historyItem.startTime ?? ''),
                        _buildInfoRow('End Time:', historyItem.endTime ?? ''),
                        _buildInfoRow(
                            'Total Time:', historyItem.formattedDuration ?? ''),
                        _buildInfoRow(
                            'Store Visits:', '${historyItem.storeCount}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return const Center(child: Text('No history available'));
  }

  Widget _buildInfoRow(String label, String value) {
    String displayValue = value;

    // Format datetime strings for start and end times
    if (label == 'Start Time:' || label == 'End Time:') {
      try {
        final dateTime = DateTime.parse(value);
        displayValue =
            '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
      } catch (e) {
        // Keep original value if parsing fails
        displayValue = value;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            displayValue,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 120,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
