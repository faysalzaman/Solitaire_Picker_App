// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solitaire_picker/constants/constant.dart';
import 'package:solitaire_picker/cubit/history/history_cubit.dart';
import 'package:solitaire_picker/cubit/history/history_state.dart';
import 'package:solitaire_picker/model/store_visit_model.dart';
import 'package:solitaire_picker/utils/app_loading.dart';

class StoreVistScreen extends StatefulWidget {
  const StoreVistScreen({
    super.key,
    required this.journeyId,
  });

  final String journeyId;

  @override
  State<StoreVistScreen> createState() => _StoreVistScreenState();
}

class _StoreVistScreenState extends State<StoreVistScreen> {
  int currentPage = 1;
  final int itemsPerPage = 10;
  bool isLoadingMore = false;
  bool hasReachedEnd = false;
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
    context.read<HistoryCubit>().getStoreVisits(
          widget.journeyId,
          "",
          currentPage.toString(),
          itemsPerPage.toString(),
          'COMPLETED',
        );
  }

  void _onSearchChanged() {
    currentPage = 1;
    context.read<HistoryCubit>().getStoreVisits(
          widget.journeyId,
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
    await context.read<HistoryCubit>().getMoreStoreVisits(
          widget.journeyId,
          "",
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Visits'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search stores...',
                      prefixIcon: const Icon(Icons.search,
                          color: AppColors.primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (value) => _onSearchChanged(),
                  ),
                ),
                Expanded(
                  child: _buildStoreVisitsContent(state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStoreVisitsContent(HistoryState state) {
    if (state is HistoryStoreVisitsLoadingState) {
      return const Center(
        child: AppLoading(
          color: AppColors.primaryColor,
          size: 20,
        ),
      );
    }

    if (state is HistoryStoreVisitsErrorState) {
      return Center(
        child: Text(
          state.message,
          style: const TextStyle(
            color: AppColors.primaryColor,
          ),
        ),
      );
    }

    if (state is HistoryStoreVisitsLoadedState) {
      final storeVisits = context.read<HistoryCubit>().storeVisits;
      final shouldShowLoadMore =
          storeVisits.length == itemsPerPage * currentPage;

      return Container(
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
          itemCount: storeVisits.length + (shouldShowLoadMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == storeVisits.length && shouldShowLoadMore) {
              return _buildLoadMoreButton(state);
            }

            final storeVisit = storeVisits[index];
            return _buildStoreVisitCard(storeVisit);
          },
        ),
      );
    }

    return const Center(child: Text('No store visits available'));
  }

  Widget _buildLoadMoreButton(
    HistoryState state,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
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

  Widget _buildStoreVisitCard(StoreVisitModel storeVisit) {
    return Card(
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
            _buildInfoRow('Store Name:', storeVisit.storeName ?? ''),
            _buildInfoRow('Entry Time:', storeVisit.entryTime ?? ''),
            _buildInfoRow('Exit Time:', storeVisit.exitTime ?? ''),
            _buildInfoRow('Duration:', storeVisit.duration.toString()),
            _buildInfoRow('Scan Type:', storeVisit.scanType ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    String displayValue = value;

    if (label == 'Entry Time:' || label == 'Exit Time:') {
      try {
        final dateTime = DateTime.parse(value);
        displayValue =
            '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      } catch (e) {
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
}
