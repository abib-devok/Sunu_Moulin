import 'package:hive/hive.dart';
import 'package:matheasy_sn/domain/entities/user_progress.dart';
import 'package:matheasy_sn/domain/repositories/progress_repository.dart';

/// Implémentation du `ProgressRepository`.
class ProgressRepositoryImpl implements ProgressRepository {
  final Box<UserProgress> progressBox;

  ProgressRepositoryImpl({required this.progressBox});

  @override
  Future<List<UserProgress>> getAllProgress() async {
    return progressBox.values.toList();
  }

  @override
  Future<void> saveProgress(UserProgress progress) async {
    // La clé pourrait être l'entityId pour un accès facile, ou un auto-increment.
    // Pour l'instant, on laisse Hive gérer les clés.
    await progressBox.add(progress);
  }
}