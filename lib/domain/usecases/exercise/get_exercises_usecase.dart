import 'package:matheasy_sn/domain/entities/exercise.dart';
import 'package:matheasy_sn/domain/repositories/exercise_repository.dart';

/// Cas d'utilisation pour récupérer les exercices d'un chapitre.
class GetExercisesUseCase {
  final ExerciseRepository repository;

  GetExercisesUseCase(this.repository);

  /// Exécute le cas d'utilisation.
  Future<List<Exercise>> call(String chapterSlug) {
    return repository.getExercisesForChapter(chapterSlug);
  }
}