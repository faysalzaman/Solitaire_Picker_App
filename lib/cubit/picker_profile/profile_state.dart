import 'package:solitaire_picker/model/user_model.dart';

class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final UserModel user;

  ProfileSuccess(this.user);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileUpdateSuccess extends ProfileState {}

class ProfileUpdateError extends ProfileState {
  final String message;

  ProfileUpdateError(this.message);
}

class FingerprintEnableDisableLoading extends ProfileState {}

class FingerprintEnableDisableSuccess extends ProfileState {}

class FingerprintEnableDisableError extends ProfileState {
  final String message;

  FingerprintEnableDisableError(this.message);
}

class NfcEnableDisableLoading extends ProfileState {}

class NfcEnableDisableSuccess extends ProfileState {}

class NfcEnableDisableError extends ProfileState {
  final String message;

  NfcEnableDisableError(this.message);
}
