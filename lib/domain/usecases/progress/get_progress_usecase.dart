import 'package:matheasy_sn/domain/entities/user_progress.dart';
import 'package:matheasy_sn/domain/repositories/progress_repository.dart';

/// Cas d'utilisation pour récupérer toute la progression de l'utilisateur.
class GetProgressUseCase {
  final ProgressRepository repository;

  GetProgressUseCase(this.repository);

  /// Exécute le cas d'utilisation.
  Future<List<UserProgress>> call() {
    return repository.getAllProgress();
  }
}