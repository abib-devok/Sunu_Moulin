import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matheasy_sn/app/core/routing/app_router.dart';

/// Modèle simple pour représenter un chapitre.
class Chapter {
  final String title;
  final String slug;
  final String section;
  final IconData icon;

  Chapter({
    required this.title,
    required this.slug,
    required this.section,
    required this.icon,
  });
}

/// Écran affichant la liste des chapitres, groupés par section.
class CoursesListScreen extends StatelessWidget {
  const CoursesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Données fictives des chapitres
    final chapters = [
      Chapter(title: "Racine carrée", slug: "racine-carree", section: "num", icon: Icons.square_foot),
      Chapter(title: "Équations et inéquations", slug: "equations-1-inconnue", section: "num", icon: Icons.equalizer),
      Chapter(title: "Systèmes d'équations", slug: "systemes-2-inconnues", section: "num", icon: Icons.functions),
      Chapter(title: "Statistique", slug: "statistique", section: "num", icon: Icons.bar_chart),
      Chapter(title: "Applications affines", slug: "applications-affines", section: "num", icon: Icons.linear_scale),
      Chapter(title: "Théorème de Thalès", slug: "theoreme-thales", section: "geo", icon: Icons.change_history),
      Chapter(title: "Angles inscrits", slug: "angles-inscrits", section: "geo", icon: Icons.circle_outlined),
      Chapter(title: "Trigonométrie", slug: "trigono-rectangle", section: "geo", icon: Icons.aspect_ratio),
      Chapter(title: "Géométrie dans l’espace", slug: "geometrie-espace", section: "geo", icon: Icons.threed_rotation),
      Chapter(title: "Vecteurs", slug: "vecteurs", section: "geo", icon: Icons.arrow_forward),
    ];

    final numericChapters = chapters.where((c) => c.section == 'num').toList();
    final geometricChapters = chapters.where((c) => c.section == 'geo').toList();

    const Color primaryColor = Color(0xFF003366);
    const Color backgroundColor = Color(0xFFF5F7F8);
    const Color cardColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.go(AppRouter.home),
        ),
        title: Text(
          'Mathématiques',
          style: GoogleFonts.lexend(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSection(
              context,
              title: 'ACTIVITÉS NUMÉRIQUES',
              chapters: numericChapters,
              primaryColor: primaryColor,
              cardColor: cardColor,
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              title: 'ACTIVITÉS GÉOMÉTRIQUES',
              chapters: geometricChapters,
              primaryColor: primaryColor,
              cardColor: cardColor,
            ),
          ],
        ),
      ),
    );
  }

  /// Construit une section pliable (numérique ou géométrique).
  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Chapter> chapters,
    required Color primaryColor,
    required Color cardColor,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          backgroundColor: cardColor,
          collapsedBackgroundColor: cardColor,
          title: Text(
            title,
            style: GoogleFonts.lexend(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          children: chapters
              .map((chapter) => _buildChapterTile(context, chapter, primaryColor))
              .toList(),
        ),
      ),
    );
  }

  /// Construit une tuile pour un chapitre individuel.
  Widget _buildChapterTile(BuildContext context, Chapter chapter, Color primaryColor) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: primaryColor.withAlpha(25),
        child: Icon(chapter.icon, color: primaryColor),
      ),
      title: Text(
        chapter.title,
        style: GoogleFonts.lexend(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      subtitle: _buildProgressIndicator(),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => context.goNamed(
        AppRouter.courseDetail,
        pathParameters: {'slug': chapter.slug},
      ),
    );
  }

  /// Construit l'indicateur de progression pour un chapitre.
  Widget _buildProgressIndicator() {
    return Row(
      children: List.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.only(right: 4, top: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: index < 2 ? Colors.amber.shade400 : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}