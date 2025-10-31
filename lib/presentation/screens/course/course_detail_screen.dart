import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matheasy_sn/data/datasources/courses/chapter_1_content.dart';
import 'package:matheasy_sn/domain/entities/course_content/course_content.dart';
import 'package:matheasy_sn/presentation/screens/course/widgets/a_retenir_widget.dart';
import 'package:matheasy_sn/presentation/screens/course/widgets/example_widget.dart';
import 'package:matheasy_sn/presentation/screens/course/widgets/math_formula_widget.dart';
import 'package:matheasy_sn/presentation/screens/course/widgets/mcq_widget.dart';
import 'package:matheasy_sn/presentation/screens/course/widgets/paragraph_widget.dart';
import 'package:matheasy_sn/presentation/screens/course/widgets/title_widget.dart';

/// Écran affichant le contenu détaillé d'un cours interactif.
class CourseDetailScreen extends StatefulWidget {
  final String slug;
  const CourseDetailScreen({super.key, required this.slug});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  // Map pour stocker la réponse de chaque QCM.
  // La clé est l'index du QCM dans la liste de contenu.
  final Map<int, int?> _mcqAnswers = {};

  @override
  Widget build(BuildContext context) {
    // Couleurs
    const Color primaryColor = Color(0xFFE53935);
    const Color secondaryColor = Color(0xFF1E88E5);
    const Color backgroundColor = Color(0xFFF5F5F5);
    const Color textColor = Color(0xFF212121);

    final courseContent = Chapter1Content.content;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: secondaryColor),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              // Note: Assurez-vous que la route '/courses' est bien définie dans votre router.
              context.go('/courses');
            }
          },
        ),
        title: Text(
          Chapter1Content.title,
          style: GoogleFonts.nunito(
              color: textColor, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          _buildCircularProgress(),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0), // Espace pour le bouton
        itemCount: courseContent.length,
        itemBuilder: (context, index) {
          final contentItem = courseContent[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _buildContentItem(contentItem, index),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ElevatedButton.icon(
          onPressed: () {
            // Note: Assurez-vous que la route nommée 'exercises' est bien définie.
            // context.goNamed('exercises', pathParameters: {'chapterSlug': widget.slug});
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

  Widget _buildContentItem(CourseContent contentItem, int index) {
    if (contentItem is TitleContent) {
      return TitleWidget(content: contentItem);
    } else if (contentItem is ParagraphContent) {
      return ParagraphWidget(content: contentItem);
    } else if (contentItem is MathFormulaContent) {
      return MathFormulaWidget(content: contentItem);
    } else if (contentItem is ARetenirContent) {
      return ARetenirWidget(content: contentItem, buildContentItem: _buildContentItem);
    } else if (contentItem is ExampleContent) {
      return ExampleWidget(content: contentItem, buildContentItem: _buildContentItem);
    } else if (contentItem is McqContent) {
      return McqWidget(
        content: contentItem,
        contentIndex: index,
        groupValue: _mcqAnswers[index],
        onAnswerChanged: (contentIndex, value) {
          setState(() {
            _mcqAnswers[contentIndex] = value;
          });
        },
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildCircularProgress() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(
          value: 0.2, // 20% de progression
          strokeWidth: 3,
          backgroundColor: Colors.grey,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E88E5)),
        ),
      ),
    );
  }
}
