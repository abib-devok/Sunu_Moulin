import 'package:matheasy_sn/domain/entities/exercise.dart';

/// Contrat pour le repository gérant les opérations liées aux exercices.
abstract class ExerciseRepository {
  /// Récupère une liste d'exercices pour un chapitre spécifique.
  Future<List<Exercise>> getExercisesForChapter(String chapterSlug);
}