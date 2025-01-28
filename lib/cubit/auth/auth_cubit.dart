// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solitaire_picker/controller/auth/auth_controller.dart';
import 'package:solitaire_picker/cubit/auth/auth_state.dart';
import 'package:solitaire_picker/utils/network_connectivity.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthController _authController = AuthController();

  Future<void> loginUser(String email, String password) async {
    emit(LoginLoading());
    try {
      final isConnected = await NetworkConnectivity.instance.checkInternet();

      if (isConnected) {
        await _authController.loginUser(email, password);
        emit(LoginSuccess());
      } else {
        emit(LoginError('No internet connection'));
      }
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  Future<void> loginWithFingerprint(String email) async {
    emit(LoginWithFingerprintLoading());
    try {
      final isConnected = await NetworkConnectivity.instance.checkInternet();

      if (isConnected) {
        await _authController.loginWithFingerprint(email);
        emit(LoginWithFingerprintSuccess());
      } else {
        emit(LoginWithFingerprintError('No internet connection'));
      }
    } catch (e) {
      emit(LoginWithFingerprintError(e.toString()));
    }
  }

  Future<void> loginWithNfc(String nfcCardId) async {
    emit(LoginWithNfcLoading());
    try {
      final isConnected = await NetworkConnectivity.instance.checkInternet();

      if (isConnected) {
        await _authController.loginWithNfc(nfcCardId);
        emit(LoginWithNfcSuccess());
      }
    } catch (e) {
      emit(LoginWithNfcError(e.toString()));
    }
  }
}
