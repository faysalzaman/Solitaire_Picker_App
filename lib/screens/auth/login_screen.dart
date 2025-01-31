// ignore_for_file: avoid_print, use_build_context_synchronously, unused_element, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:solitaire_picker/constants/constant.dart';
import 'package:solitaire_picker/cubit/auth/auth_cubit.dart';
import 'package:solitaire_picker/cubit/auth/auth_state.dart';
import 'package:solitaire_picker/screens/dashboard/dashboard_screen.dart';
import 'package:solitaire_picker/utils/app_loading.dart';
import 'package:solitaire_picker/utils/app_navigator.dart';
import 'package:solitaire_picker/utils/app_preferences.dart';
import 'package:solitaire_picker/widgets/error_dialog.dart';
import 'package:solitaire_picker/widgets/nfc_scan_dialog.dart';
import 'package:solitaire_picker/widgets/success_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final LocalAuthentication _localAuth = LocalAuthentication();
  late AnimationController _animationController;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool? hasNfc;
  bool? hasFingerprint;

  static const int _blinkCount = 3;
  int _currentBlinkCount = 0;
  bool _isBlinking = false;

  bool _hasAttemptedFingerprint = false;
  bool _hasAttemptedNfc = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    hasNfc = AppPreferences.getHasNfc();
    hasFingerprint = AppPreferences.getHasFingerprint();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addStatusListener((status) {
        if (!_isBlinking) return;

        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          if (_currentBlinkCount >= _blinkCount * 2) {
            _isBlinking = false;
            _animationController.value = 1.0;
            _currentBlinkCount = 0;
          } else {
            _currentBlinkCount++;
            Future.delayed(const Duration(milliseconds: 200), () {
              if (mounted && _isBlinking) {
                _animationController.forward();
              }
            });
          }
        }
      });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No biometrics available on this device'),
            ),
          );
        }
        return;
      }

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => StatefulBuilder(
            builder: (builderContext, setState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Fingerprint Authentication\nto Login',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.purpleColor,
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset('assets/scan_finger.png'),
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondaryColor,
                          ),
                          onPressed: () async {
                            try {
                              final bool didAuthenticate =
                                  await _localAuth.authenticate(
                                localizedReason: 'Please authenticate to login',
                                options: const AuthenticationOptions(
                                  stickyAuth: true,
                                  biometricOnly: true,
                                ),
                              );

                              if (didAuthenticate && mounted) {
                                final String? email = AppPreferences.getEmail();
                                if (email != null) {
                                  await context
                                      .read<AuthCubit>()
                                      .loginWithFingerprint(email);
                                } else {
                                  Navigator.pop(dialogContext);
                                  _showWarningMessage(
                                      'No saved email found. Please login with credentials first');
                                }
                              }
                            } on PlatformException catch (e) {
                              print('Authentication error: $e');
                              if (mounted) {
                                Navigator.pop(dialogContext);
                                _showWarningMessage(
                                    'Authentication failed. Please try again.');
                                _restartBlink();
                              }
                            }
                          },
                          child: const Text(
                            'Click to Scan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }
    } on PlatformException catch (e) {
      print('Platform Exception: $e');
      _showWarningMessage('Authentication failed. Please try again.');
    }
  }

  void _restartBlink() {
    setState(() {
      if (!_isBlinking) {
        _isBlinking = true;
        _currentBlinkCount = 0;
        _animationController.value = 1.0;
        _animationController.forward();
      }
    });
  }

  void _showSuccessDialog(String title) {
    SuccessDialog.show(
      context,
      title: title,
      buttonText: 'OK',
    );
  }

  void _showWarningMessage(String message) {
    ErrorDialog.show(
      context,
      title: message,
      buttonText: 'OK',
    );
    _restartBlink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            AppNavigator.pushReplacement(context, const DashboardScreen());
            _showSuccessDialog('Login Successfully');
          } else if (state is LoginError) {
            _showWarningMessage(state.message);
          } else if (state is LoginWithFingerprintError) {
            _showWarningMessage(state.message.replaceAll('Exception: ', ''));
          } else if (state is LoginWithFingerprintLoading) {
            showDialog(
              context: context,
              builder: (context) => const Center(
                child: AppLoading(
                  color: Colors.white,
                  size: 20,
                ),
              ),
            );
          } else if (state is LoginWithFingerprintSuccess) {
            Navigator.pop(context); // Close dialog
            AppNavigator.pushReplacement(context, const DashboardScreen());
            _showSuccessDialog('Login Successfully');
          } else if (state is LoginWithNfcSuccess) {
            AppNavigator.pushReplacement(context, const DashboardScreen());
            _showSuccessDialog('Login Successfully');
          } else if (state is LoginWithNfcError) {
            _showWarningMessage(state.message.replaceAll('Exception: ', ''));
          }
        },
        builder: (context, state) {
          return Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
                opacity: 0.8,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'SOLITAIRE',
                        style: TextStyle(
                          fontSize: 28,
                          color: AppColors.primaryColor,
                          letterSpacing: 10,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // here...
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: TextField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          onSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter Email Address',
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            isDense: true,
                            constraints: const BoxConstraints(
                              maxHeight: 40,
                            ),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Colors.grey,
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) {
                            _passwordFocusNode.unfocus();
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter Password',
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            isDense: true,
                            constraints: const BoxConstraints(
                              maxHeight: 40,
                            ),
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Colors.grey,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      // login button
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.primaryColor,
                        ),
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            BlocProvider.of<AuthCubit>(context).loginUser(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                          },
                          child: state is LoginLoading
                              ? const AppLoading(
                                  color: Colors.white,
                                  size: 20,
                                )
                              : const Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      const Text(
                        'Or Login With',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          state is LoginWithFingerprintLoading
                              ? const AppLoading(
                                  color: Colors.white,
                                  size: 80,
                                )
                              : Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.transparent,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (hasFingerprint == true) {
                                        _authenticate();
                                      } else {
                                        _hasAttemptedFingerprint = true;
                                        _showWarningMessage(
                                            'Please enable fingerprint authentication in User Profile Settings');
                                        _restartBlink();
                                      }
                                    },
                                    child: FadeTransition(
                                      opacity: (hasFingerprint == false &&
                                              _hasAttemptedFingerprint)
                                          ? _animationController
                                          : const AlwaysStoppedAnimation(1.0),
                                      child: SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: Image.asset(
                                          'assets/finger.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 30),
                          const Text(
                            'OR',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 30),
                          state is LoginWithNfcLoading
                              ? const AppLoading(
                                  color: Colors.white,
                                  size: 80,
                                )
                              : Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.transparent,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (hasNfc == true) {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return NFCScanDialog(
                                              authCubit:
                                                  BlocProvider.of<AuthCubit>(
                                                      context),
                                            );
                                          },
                                        );
                                      } else {
                                        _hasAttemptedNfc = true;
                                        _showWarningMessage(
                                            'Please enable NFC in User Profile Settings');
                                        _restartBlink();
                                      }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 20),
                                      width: 80,
                                      height: 90,
                                      child: FadeTransition(
                                        opacity: (hasNfc == false &&
                                                _hasAttemptedNfc)
                                            ? _animationController
                                            : const AlwaysStoppedAnimation(1.0),
                                        child: Image.asset(
                                          'assets/nfc.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 150,
                            height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.primaryColor.withOpacity(0.8),
                              ),
                              onPressed: () {},
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: 0.8,
                            child: SizedBox(
                              width: 150,
                              height: 40,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black38,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
