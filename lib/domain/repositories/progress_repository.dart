import 'package:matheasy_sn/domain/entities/user_progress.dart';

/// Contrat pour le repository gérant les opérations liées à la progression de l'utilisateur.
abstract class ProgressRepository {
  /// Récupère toute la progression de l'utilisateur.
  Future<List<UserProgress>> getAllProgress();

  /// Sauvegarde une nouvelle entrée de progression.
  Future<void> saveProgress(UserProgress progress);
}