import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solitaire_picker/controller/picker/picker_controller.dart';
import 'package:solitaire_picker/cubit/picker/picker_state.dart';
import 'package:solitaire_picker/model/active_picker_model.dart';

class PickerCubit extends Cubit<PickerState> {
  PickerCubit() : super(PickerInitialState());

  final PickerController _pickerController = PickerController();

  List<ActivePickerModel> pickers = [];

  static PickerCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> getPickers(int page, int limit) async {
    emit(PickerLoadingState());
    try {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        emit(PickerErrorState('No internet connection'));
        return;
      }
      final pickers = await _pickerController.getPickers(page, limit);
      this.pickers = pickers;
      emit(PickerSuccessState(pickers));
    } catch (error) {
      emit(PickerErrorState(error.toString()));
    }
  }

  Future<void> submitReview(
      String pickerId, double rating, String comments) async {
    emit(PickerReviewLoadingState());
    try {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        emit(PickerReviewErrorState('No internet connection'));
        return;
      }
      await _pickerController.submitReview(pickerId, rating, comments);
      emit(PickerReviewSuccessState());
      getPickers(1, 10);
    } catch (error) {
      emit(PickerReviewErrorState(error.toString()));
    }
  }
}
