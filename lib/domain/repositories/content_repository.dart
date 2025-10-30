/// Contrat pour le repository gérant le contenu pédagogique.
abstract class ContentRepository {
  /// Récupère tous les chapitres depuis le backend.
  Future<void> fetchAndStoreChapters();

  /// Récupère tous les exercices depuis le backend.
  Future<void> fetchAndStoreExercises();

  /// Récupère un chapitre spécifique depuis le stockage local.
  // Future<Chapter> getChapter(String slug);
}