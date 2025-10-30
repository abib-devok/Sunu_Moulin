import 'package:hive/hive.dart';

part 'user_progress.g.dart';

/// Modèle pour stocker la progression de l'utilisateur pour une entité spécifique (chapitre, quiz).
@HiveType(typeId: 0)
class UserProgress extends HiveObject {
  /// Identifiant unique de l'entité (ex: 'racine-carree' ou 'bfem-2023').
  @HiveField(0)
  final String entityId;

  /// Score obtenu par l'utilisateur.
  @HiveField(1)
  final int score;

  /// Nombre total de questions ou de points possibles.
  @HiveField(2)
  final int total;

  /// Date à laquelle la progression a été enregistrée.
  @HiveField(3)
  final DateTime date;

  UserProgress({
    required this.entityId,
    required this.score,
    required this.total,
    required this.date,
  });
}