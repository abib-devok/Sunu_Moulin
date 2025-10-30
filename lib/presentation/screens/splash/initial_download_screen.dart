import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matheasy_sn/app/core/routing/app_router.dart';
import 'package:matheasy_sn/app/di/injector.dart';
import 'package:matheasy_sn/presentation/blocs/content/content_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Écran conteneur qui fournit le BLoC à l'écran de téléchargement.
class InitialDownloadScreen extends StatelessWidget {
  const InitialDownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ContentBloc>()..add(DownloadInitialContent()),
      child: const InitialDownloadView(),
    );
  }
}

/// Vue pour le téléchargement initial du contenu de l'application.
class InitialDownloadView extends StatelessWidget {
  const InitialDownloadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003366),
      body: BlocConsumer<ContentBloc, ContentState>(
        listener: (context, state) async {
          if (state.status == ContentStatus.success) {
            final prefs = sl<SharedPreferences>();
            await prefs.setBool('content_downloaded', true);
            // La vérification `mounted` est déjà faite, mais on la laisse par sécurité.
            if (context.mounted) {
              context.go(AppRouter.home);
            }
          }
          if (state.status == ContentStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? 'Erreur inconnue')),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_download, color: Colors.white, size: 80),
                  const SizedBox(height: 24),
                  Text(
                    'Premier Démarrage',
                    style: GoogleFonts.lexend(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Veuillez patienter pendant le téléchargement du contenu des cours pour une utilisation hors ligne.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      color: Colors.white.withAlpha(230),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 48),
                  LinearProgressIndicator(
                    value: state.progress,
                    backgroundColor: Colors.white.withAlpha(77),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                    minHeight: 10,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: GoogleFonts.nunito(
                      color: Colors.white.withAlpha(204),
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
}