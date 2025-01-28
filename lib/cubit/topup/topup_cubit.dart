// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:solitaire_picker/controller/topup/topup_controller.dart';
// import 'package:solitaire_picker/cubit/topup/topup_state.dart';
// import 'package:solitaire_picker/model/payment_history_model.dart';

// class TopupCubit extends Cubit<TopupState> {
//   TopupCubit() : super(SubmitTopupInitialState());

//   final TopupController _topupController = TopupController();

//   List<PaymentHistory> paymentHistory = [];

//   static TopupCubit get(BuildContext context) => BlocProvider.of(context);

//   Future<void> submitTopup(double amount, String paymentMethod) async {
//     emit(SubmitTopupLoadingState());
//     try {
//       if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
//         emit(SubmitTopupErrorState('No internet connection'));
//         return;
//       }
//       await _topupController.topup(amount, paymentMethod);
//       emit(SubmitTopupSuccessState());
//     } catch (error) {
//       emit(SubmitTopupErrorState(error.toString()));
//     }
//   }

//   Future<void> getPaymentHistory(
//     int page,
//     int limit,
//   ) async {
//     emit(GetPaymentHistoryLoadingState());
//     try {
//       if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
//         emit(GetPaymentHistoryErrorState('No internet connection'));
//         return;
//       }
//       final paymentHistory =
//           await _topupController.getPaymentHistory(page, limit);
//       this.paymentHistory = paymentHistory;
//       emit(GetPaymentHistorySuccessState(paymentHistory));
//     } catch (error) {
//       print(error);
//       emit(GetPaymentHistoryErrorState(error.toString()));
//     }
//   }
// }
