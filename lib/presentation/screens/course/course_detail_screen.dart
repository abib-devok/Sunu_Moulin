import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:matheasy_sn/app/core/routing/app_router.dart';

/// Écran affichant le contenu détaillé d'un cours interactif.
class CourseDetailScreen extends StatelessWidget {
  final String slug;
  const CourseDetailScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    // Couleurs basées sur la maquette "Screen 4"
    const Color primaryColor = Color(0xFFE53935);
    const Color secondaryColor = Color(0xFF1E88E5);
    const Color backgroundColor = Color(0xFFF5F5F5);
    const Color textColor = Color(0xFF212121);
    const Color successColor = Color(0xFF4CAF50);

    // Contenu Markdown factice pour la leçon
    const String markdownContent = """
## 1️⃣ Définition
La **racine carrée** d'un nombre `a` est le nombre positif qui, une fois multiplié par lui-même, donne `a`.
On la note `√a`.

*Exemple :* `√16 = 4` car `4 x 4 = 16`.

## 2️⃣ Propriétés importantes
- `√(a²)` = a (si a est positif)
- `√a * √b = √(a*b)`
- `√a / √b = √(a/b)`

## 3️⃣ Résumé
- `√0 = 0`
- `√1 = 1`
""";

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: secondaryColor),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Leçon : Racine carrée',
          style: GoogleFonts.nunito(
              color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          _buildCircularProgress(),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildObjectivesCard(successColor),
            const SizedBox(height: 16),
            _buildContentCard(
                "Qu'est-ce qu'une racine carrée ?",
                Icons.square_foot,
                secondaryColor,
                markdownContent),
            const SizedBox(height: 16),
            _buildMcqCard(
                "Question 1 : Quelle est la racine carrée de 25 ?",
                ["4", "5", "6"],
                1, // Index de la bonne réponse
                secondaryColor,
                successColor,
                primaryColor),
            const SizedBox(height: 80), // Espace pour le bouton flottant
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ElevatedButton.icon(
          onPressed: () {
             context.goNamed(AppRouter.exercises, pathParameters: {'chapterSlug': slug});
          },
          icon: const Icon(Icons.arrow_forward),
          label: const Text('EXERCICES DU CHAPITRE'),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircularProgress() {
    return const SizedBox(
      width: 32,
      height: 32,
      child: CircularProgressIndicator(
        value: 0.2, // 20% de progression
        strokeWidth: 3,
        backgroundColor: Colors.grey,
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E88E5)),
      ),
    );
  }

  Widget _buildObjectivesCard(Color successColor) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Objectifs d\'apprentissage',
                style: GoogleFonts.nunito(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildObjectiveItem(
                'Comprendre la définition', successColor),
            _buildObjectiveItem(
                'Savoir simplifier une racine', successColor),
          ],
        ),
      ),
    );
  }

  Widget _buildObjectiveItem(String text, Color color) {
    return Row(
      children: [
        Icon(Icons.check_circle, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
            child: Text(text,
                style: GoogleFonts.nunito(fontSize: 16))),
      ],
    );
  }

  Widget _buildContentCard(
      String title, IconData icon, Color color, String content) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                    backgroundColor: color.withOpacity(0.1),
                    child: Icon(icon, color: color)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(title,
                      style: GoogleFonts.nunito(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            MarkdownBody(
              data: content,
              styleSheet: MarkdownStyleSheet.fromTheme(ThemeData(
                textTheme: TextTheme(
                  bodyMedium: GoogleFonts.nunito(fontSize: 16, height: 1.5),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMcqCard(String question, List<String> options, int correctIndex,
      Color secondary, Color success, Color error) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: secondary.withOpacity(0.5), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question,
                style: GoogleFonts.nunito(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...options.asMap().entries.map((entry) {
              int idx = entry.key;
              String text = entry.value;
              return RadioListTile<int>(
                title: Text(text, style: GoogleFonts.nunito()),
                value: idx,
                groupValue:
                    -1, // Simule un état non sélectionné pour la démo
                onChanged: (int? value) {
                  // Logique de vérification
                },
                activeColor: success,
              );
            }),
          ],
        ),
      ),
    );
  }
}