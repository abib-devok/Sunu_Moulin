import 'package:equatable/equatable.dart';

/// Type d'exercice (Question à Choix Multiple, Saisie, Vrai/Faux).
enum ExerciseType { qcm, input, trueFalse }

/// Représente un exercice individuel.
class Exercise extends Equatable {
  final String id;
  final String chapterSlug;
  final String question;
  final ExerciseType type;
  final List<String>? options; // Pour les QCM
  final String correctAnswer;

  const Exercise({
    required this.id,
    required this.chapterSlug,
    required this.question,
    required this.type,
    this.options,
    required this.correctAnswer,
  });

  @override
  List<Object?> get props => [id, chapterSlug, question, type, options, correctAnswer];
}