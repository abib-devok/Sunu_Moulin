import 'package:matheasy_sn/domain/entities/user_progress.dart';
import 'package:matheasy_sn/domain/repositories/progress_repository.dart';

/// Cas d'utilisation pour sauvegarder la progression de l'utilisateur.
class SaveProgressUseCase {
  final ProgressRepository repository;

  SaveProgressUseCase(this.repository);

  /// Exécute le cas d'utilisation.
  Future<void> call(UserProgress progress) {
    return repository.saveProgress(progress);
  }
}