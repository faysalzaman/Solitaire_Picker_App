import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solitaire_picker/controller/history/history_controller.dart';
import 'package:solitaire_picker/cubit/history/history_state.dart';
import 'package:solitaire_picker/model/history_model.dart';
import 'package:solitaire_picker/model/store_visit_model.dart';
import 'package:solitaire_picker/utils/app_preferences.dart';
import 'package:solitaire_picker/utils/network_connectivity.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial());

  final HistoryController _historyController = HistoryController();

  List<HistoryModel> history = [];
  List<StoreVisitModel> storeVisits = [];
  bool hasReachedEnd = false;
  bool hasReachedEndStoreVisits = false;

  Future<void> getHistory(
      String search, String page, String limit, String status) async {
    emit(HistoryLoadingState());

    final userId = AppPreferences.getUserId();

    try {
      final isConnected = await NetworkConnectivity.instance.checkInternet();

      if (isConnected) {
        history = await _historyController.getHistory(
          userId ?? '',
          search,
          page,
          limit,
          status,
        );
        hasReachedEnd = history.isEmpty || history.length < int.parse(limit);
        emit(HistoryLoadedState(history));
      } else {
        emit(HistoryErrorState('No internet connection'));
      }
    } catch (e) {
      emit(HistoryErrorState(e.toString()));
    }
  }

  Future<void> getMoreHistory(
      String search, String page, String limit, String status) async {
    try {
      final result = await _historyController.getHistory(
        AppPreferences.getUserId() ?? '',
        search,
        page,
        limit,
        status,
      );
      history.addAll(result);
      hasReachedEnd = result.isEmpty || result.length < int.parse(limit);
      emit(HistoryLoadedState(history));
    } catch (e) {
      emit(HistoryErrorState(e.toString()));
    }
  }

  Future<void> getStoreVisits(
    String journeyId,
    String search,
    String page,
    String limit,
    String status,
  ) async {
    emit(HistoryStoreVisitsLoadingState());

    try {
      final isConnected = await NetworkConnectivity.instance.checkInternet();

      if (isConnected) {
        storeVisits = await _historyController.getStoresByJourneyId(
          journeyId,
          search,
          page,
          limit,
          status,
        );
        emit(HistoryStoreVisitsLoadedState(storeVisits));
      } else {
        emit(HistoryStoreVisitsErrorState('No internet connection'));
      }
    } catch (e) {
      emit(HistoryStoreVisitsErrorState(e.toString()));
    }
  }

  Future<void> getMoreStoreVisits(String journeyId, String search, String page,
      String limit, String status) async {
    try {
      final isConnected = await NetworkConnectivity.instance.checkInternet();

      if (isConnected) {
        final result = await _historyController.getStoresByJourneyId(
          journeyId,
          search,
          page,
          limit,
          status,
        );
        storeVisits.addAll(result);
        hasReachedEndStoreVisits =
            result.isEmpty || result.length < int.parse(limit);
        emit(HistoryStoreVisitsLoadedMoreState(storeVisits));
      } else {
        emit(HistoryStoreVisitsErrorState('No internet connection'));
      }
    } catch (e) {
      emit(HistoryStoreVisitsErrorState(e.toString()));
    }
  }
}
