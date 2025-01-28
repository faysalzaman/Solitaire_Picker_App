class AuthState {}

class AuthInitial extends AuthState {}

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {}

class LoginError extends AuthState {
  final String message;

  LoginError(this.message);
}

class LoginWithFingerprintLoading extends AuthState {}

class LoginWithFingerprintSuccess extends AuthState {}

class LoginWithFingerprintError extends AuthState {
  final String message;

  LoginWithFingerprintError(this.message);
}

class LoginWithNfcLoading extends AuthState {}

class LoginWithNfcSuccess extends AuthState {}

class LoginWithNfcError extends AuthState {
  final String message;

  LoginWithNfcError(this.message);
}
