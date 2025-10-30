import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matheasy_sn/app/core/routing/app_router.dart';
import 'package:matheasy_sn/app/di/injector.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Écran pour le téléchargement initial du contenu de l'application.
class InitialDownloadScreen extends StatefulWidget {
  const InitialDownloadScreen({super.key});

  @override
  State<InitialDownloadScreen> createState() => _InitialDownloadScreenState();
}

class _InitialDownloadScreenState extends State<InitialDownloadScreen> {
  double _progress = 0.0;
  String _status = 'Initialisation...';

  @override
  void initState() {
    super.initState();
    _startDownload();
  }

  Future<void> _startDownload() async {
    // Simule le téléchargement et l'insertion des données
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _status = 'Téléchargement des cours...';
      _progress = 0.25;
    });
    // TODO: Appeler le service pour télécharger et insérer les cours

    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _status = 'Installation des exercices...';
      _progress = 0.6;
    });
    // TODO: Appeler le service pour télécharger et insérer les exercices

    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _status = 'Préparation des épreuves BFEM...';
      _progress = 0.9;
    });
    // TODO: Appeler le service pour télécharger les PDF des épreuves

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _status = 'Finalisation...';
      _progress = 1.0;
    });

    // Naviguer vers l'écran d'accueil
    final prefs = sl<SharedPreferences>();
    await prefs.setBool('content_downloaded', true);

    if (mounted) {
      context.go(AppRouter.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003366),
      body: Center(
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
                'Veuillez patienter pendant le téléchargement du contenu des cours pour une utilisation hors ligne. (Environ 180 Mo)',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: Colors.white.withAlpha(230),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 48),
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.white.withAlpha(77),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                minHeight: 10,
              ),
              const SizedBox(height: 16),
              Text(
                _status,
                style: GoogleFonts.nunito(
                  color: Colors.white.withAlpha(204),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}