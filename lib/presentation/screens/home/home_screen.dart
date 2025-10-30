import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:matheasy_sn/app/core/routing/app_router.dart';
import 'package:matheasy_sn/presentation/blocs/auth/auth_bloc.dart';

/// Écran principal de l'application (Accueil).
///
/// Affiche les 4 sections principales de l'application sous forme de grille
/// et sert de point de départ pour la navigation de l'utilisateur.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF003366);
    const Color backgroundColor = Color(0xFFF5F7F8);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Accueil', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          // Indicateur de mode hors ligne
          IconButton(
            icon: const Icon(Icons.wifi_off, color: Colors.grey),
            onPressed: () {
              // Action pour l'indicateur (peut-être afficher un message)
            },
          ),
        ],
      ),
      drawer: _buildAppDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildGridItem(
              context: context,
              icon: Icons.auto_stories_outlined,
              title: 'COURS',
              subtitle: 'Leçons et chapitres',
              color: primaryColor,
              onTap: () => context.go(AppRouter.courses),
            ),
            _buildGridItem(
              context: context,
              icon: Icons.edit_outlined,
              title: 'EXERCICES',
              subtitle: 'Problèmes pratiques',
              color: primaryColor,
              onTap: () => context.go(AppRouter.exercises.replaceFirst('/:chapterSlug', '')),
            ),
            _buildGridItem(
              context: context,
              icon: Icons.quiz_outlined,
              title: 'ÉPREUVE BFEM',
              subtitle: 'Examens blancs',
              color: primaryColor,
              onTap: () => context.go(AppRouter.bfem),
            ),
            _buildGridItem(
              context: context,
              icon: Icons.bar_chart_outlined,
              title: 'MES PROGRÈS',
              subtitle: 'Suivi des performances',
              color: primaryColor,
              onTap: () => context.go(AppRouter.progress),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit le menu latéral (Drawer).
  Widget _buildAppDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF003366),
            ),
            child: Text(
              'MathEasy SN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Déconnexion'),
            onTap: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
              context.pop(); // Ferme le drawer
            },
          ),
        ],
      ),
    );
  }

  /// Construit un élément de la grille de l'écran d'accueil.
  Widget _buildGridItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}