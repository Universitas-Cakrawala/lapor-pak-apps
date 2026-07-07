import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (Skip on Web unless configured with options)
  if (!kIsWeb) {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      debugPrint('Firebase init failed: $e');
    }
  }

  // Initialize dependency injection
  setupServiceLocator();
  
  // Format Date for id_ID
  await initializeDateFormatting('id_ID', null);

  runApp(const LaporPakApp());
}

class LaporPakApp extends StatelessWidget {
  const LaporPakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'Lapor Pak!',
            debugShowCheckedModeBanner: false,
            theme: buildAppTheme(),
            darkTheme: buildDarkAppTheme(),
            themeMode: themeMode,
            scaffoldMessengerKey: scaffoldMessengerKey,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
