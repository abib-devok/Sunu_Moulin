import 'package:equatable/equatable.dart';

/// Classe abstraite représentant un élément de contenu de cours.
abstract class CourseContent extends Equatable {
  const CourseContent();

  @override
  List<Object> get props => [];
}

/// Contenu de type Titre (H1, H2, etc.)
class TitleContent extends CourseContent {
  final String text;
  final int level; // e.g., 1 for H1, 2 for H2

  const TitleContent(this.text, {this.level = 1});

  @override
  List<Object> get props => [text, level];
}

/// Contenu de type Paragraphe de texte
class ParagraphContent extends CourseContent {
  final String text;

  const ParagraphContent(this.text);

  @override
  List<Object> get props => [text];
}

/// Contenu de type Formule Mathématique
class MathFormulaContent extends CourseContent {
  /// La formule en format TeX. Exemple: '\\sqrt{a^2} = a'
  final String texExpression;

  const MathFormulaContent(this.texExpression);

  @override
  List<Object> get props => [texExpression];
}

/// Contenu de type "À retenir" (encadré)
class ARetenirContent extends CourseContent {
  final String title;
  final List<CourseContent> content;

  const ARetenirContent({required this.title, required this.content});

  @override
  List<Object> get props => [title, content];
}

/// Contenu de type Exemple
class ExampleContent extends CourseContent {
  final String title;
  final List<CourseContent> content;

  const ExampleContent({required this.title, required this.content});

  @override
  List<Object> get props => [title, content];
}

/// Contenu de type Question à Choix Multiple (QCM)
class McqContent extends CourseContent {
  final String question;
  final List<String> options;
  final int correctOptionIndex;

  const McqContent({
    required this.question,
    required this.options,
    required this.correctOptionIndex,
  });

  @override
  List<Object> get props => [question, options, correctOptionIndex];
}
