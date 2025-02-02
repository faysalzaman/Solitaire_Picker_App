import 'package:solitaire_picker/model/history_model.dart';
import 'package:solitaire_picker/model/store_visit_model.dart';

class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoadingState extends HistoryState {}

class HistoryLoadingMoreState extends HistoryState {}

class HistoryLoadedState extends HistoryState {
  final List<HistoryModel> history;

  HistoryLoadedState(this.history);
}

class HistoryLoadedMoreState extends HistoryState {
  final List<HistoryModel> history;

  HistoryLoadedMoreState(this.history);
}

class HistoryErrorState extends HistoryState {
  final String message;

  HistoryErrorState(this.message);
}

class HistoryStoreVisitsLoadedState extends HistoryState {
  final List<StoreVisitModel> storeVisits;

  HistoryStoreVisitsLoadedState(this.storeVisits);
}

class HistoryStoreVisitsLoadedMoreState extends HistoryState {
  final List<StoreVisitModel> storeVisits;

  HistoryStoreVisitsLoadedMoreState(this.storeVisits);
}

class HistoryStoreVisitsLoadingState extends HistoryState {}

class HistoryStoreVisitsLoadingMoreState extends HistoryState {}

class HistoryStoreVisitsErrorState extends HistoryState {
  final String message;

  HistoryStoreVisitsErrorState(this.message);
}
