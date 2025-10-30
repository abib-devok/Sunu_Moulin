import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Écran de démarrage de l'application (Splash Screen).
///
/// Affiche le logo et le nom de l'application pendant que les
/// services initiaux sont chargés.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00853F), // Couleur de fond du drapeau Sénégalais
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            // Logo
            Center(
              child: Image.network(
                "https://lh3.googleusercontent.com/aida-public/AB6AXuAKn5nwiALqP9b8dG5gGONdCgkPdiEBvP18ZENy23TpZbUq7MIVmWDXyH4Y95VLazALXuVcA29ZGPwxX4fvvZhMIyBeGlVwaDqeDkoSN6o4zkC-Z7jk4A6-pNO9KNeI-aPUmZiGc7FXf9MhrfNDGfOXakcY5R5W47b3YPynUFe5YFIF-N2K_hKyeFbq6dNmFsFQUWDX4B0DRiYetX6lWPRELcUQ0aCP5I8CAnXcRB17_NUuelkBI_a1ulD3IRUKOBNONadPNmVlBdg",
                height: 120,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.school, size: 120, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            // Titre de l'application
            Text(
              'MathEasy SN',
              textAlign: TextAlign.center,
              style: GoogleFonts.lexend(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Slogan
            Text(
              "Réussir le BFEM, c'est facile !",
              textAlign: TextAlign.center,
              style: GoogleFonts.lexend(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
              ),
            ),
            const Spacer(),
            // Barre de progression
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 32.0),
              child: Column(
                children: [
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: LinearProgressIndicator(
                        value: _animation.value,
                        backgroundColor: Colors.transparent,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFDEF42)), // Jaune drapeau
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Chargement...',
                    style: GoogleFonts.lexend(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}