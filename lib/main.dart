import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:solitaire_picker/cubit/auth/auth_cubit.dart';
import 'package:solitaire_picker/cubit/history/history_cubit.dart';
import 'package:solitaire_picker/cubit/journey/journey_cubit.dart';
import 'package:solitaire_picker/cubit/picker_profile/profile_cubit.dart';
import 'package:solitaire_picker/cubit/picker/picker_cubit.dart';
import 'package:solitaire_picker/cubit/store/store_cubit.dart';
import 'package:solitaire_picker/screens/auth/login_screen.dart';
import 'package:solitaire_picker/utils/app_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await AppPreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
        // BlocProvider(create: (context) => TopupCubit()),
        BlocProvider(create: (context) => PickerCubit()),
        BlocProvider(create: (context) => StoreCubit()),
        BlocProvider(create: (context) => JourneyCubit()),
        BlocProvider(create: (context) => HistoryCubit())
      ],
      child: MaterialApp(
        title: 'Solitaire Picker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const LoginScreen(),
      ),
    );
  }
}
