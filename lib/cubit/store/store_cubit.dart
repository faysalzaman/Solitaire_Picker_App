import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solitaire_picker/controller/store/store_controller.dart';
import 'package:solitaire_picker/cubit/store/store_state.dart';
import 'package:solitaire_picker/model/store_model.dart';
import 'package:solitaire_picker/utils/network_connectivity.dart';

class StoreCubit extends Cubit<StoreState> {
  StoreCubit() : super(StoreInitial());

  List<StoreModel> stores = [];

  Future<void> getStores(String search, int page, int limit) async {
    emit(StoreLoading());
    try {
      // internet check
      final isConnected = await NetworkConnectivity.instance.checkInternet();

      if (!isConnected) {
        emit(StoreError(message: "No internet connection"));
        return;
      }

      stores = await StoreController().getStores(search, page, limit);
      emit(StoreLoaded(stores: stores));
    } catch (e) {
      print(e);
      emit(StoreError(message: e.toString()));
    }
  }

  Future<void> getStoreByQRCode(String qrCode) async {
    emit(StoreLoading());
    try {
      stores.clear();
      stores.add(await StoreController().getStoreByQRCode(qrCode));
      emit(StoreGetByQRCode(store: stores[0]));
    } catch (e) {
      emit(StoreGetByQRCodeError(message: e.toString()));
    }
  }

  Future<void> getStoreByNFC(String nfc) async {
    emit(StoreLoading());
    try {
      stores.clear();
      stores.add(await StoreController().getStoreByNFC(nfc));
      emit(StoreGetByNFC(store: stores[0]));
    } catch (e) {
      emit(StoreGetByNFCError(message: e.toString()));
    }
  }
}
