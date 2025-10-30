import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matheasy_sn/app/core/routing/app_router.dart';
import 'package:matheasy_sn/app/core/theme/app_theme.dart';
import 'package:matheasy_sn/app/di/injector.dart' as di;
import 'package:matheasy_sn/data/datasources/local/hive_service.dart';
import 'package:matheasy_sn/presentation/blocs/auth/auth_bloc.dart';

Future<void> main() async {
  // Assure que les bindings Flutter sont initialisés
  WidgetsFlutterBinding.ensureInitialized();
  // Initialise Hive
  await HiveService.init();
  // Initialise l'injection de dépendances
  await di.init();
  runApp(const MathEasyApp());
}

/// Widget racine de l'application MathEasy SN.
class MathEasyApp extends StatelessWidget {
  const MathEasyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Fournit le AuthBloc à l'ensemble de l'application en utilisant GetIt.
    return BlocProvider(
      create: (context) => di.sl<AuthBloc>()..add(AuthStatusChecked()),
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: 'MathEasy SN',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            routerConfig: AppRouter.getRouter(context),
          );
        }
      ),
    );
  }
}