import 'package:solitaire_picker/model/store_model.dart';

class StoreState {}

class StoreInitial extends StoreState {}

class StoreLoading extends StoreState {}

class StoreLoaded extends StoreState {
  final List<StoreModel> stores;

  StoreLoaded({required this.stores});
}

class StoreError extends StoreState {
  final String message;

  StoreError({required this.message});
}

class StoreGetByQRCode extends StoreState {
  final StoreModel store;

  StoreGetByQRCode({required this.store});
}

class StoreGetByQRCodeError extends StoreState {
  final String message;

  StoreGetByQRCodeError({required this.message});
}

class StoreGetByNFC extends StoreState {
  final StoreModel store;

  StoreGetByNFC({required this.store});
}

class StoreGetByNFCError extends StoreState {
  final String message;

  StoreGetByNFCError({required this.message});
}
