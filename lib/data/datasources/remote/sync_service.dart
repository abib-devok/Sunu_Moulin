import 'package:matheasy_sn/domain/repositories/progress_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service responsable de la synchronisation des données locales vers le backend.
class SyncService {
  final ProgressRepository progressRepository;
  final SupabaseClient supabaseClient;

  SyncService({
    required this.progressRepository,
    required this.supabaseClient,
  });

  /// Tente de synchroniser les données de progression non synchronisées.
  Future<void> syncProgress() async {
    // Étape 1: Vérifier la connexion Internet (simulé pour l'instant)
    const bool isConnected = true; // TODO: Remplacer par une vraie vérification de connectivité
    if (isConnected) {
      // Étape 2: Récupérer les données de progression locales
      final localProgress = await progressRepository.getAllProgress();
      if (localProgress.isEmpty) {
        return;
      }

      // Étape 3: Préparer les données pour l'envoi
      // final List<Map<String, dynamic>> payload = localProgress.map((progress) {
      //   return {
      //     'entity_id': progress.entityId,
      //     'score': progress.score,
      //     'total': progress.total,
      //     'created_at': progress.date.toIso8601String(),
      //     // 'user_id' serait nécessaire dans une vraie application
      //   };
      // }).toList();

      // Étape 4: Envoyer les données à Supabase
      try {
        // On utiliserait une fonction RPC ou un insert direct sur une table 'user_progress'
        // final response = await supabaseClient.from('user_progress').upsert(payload);

        // Simule un succès
        await Future.delayed(const Duration(seconds: 2));

        // Étape 5 (Optionnel): Marquer les données comme synchronisées localement
        // pour ne pas les renvoyer à chaque fois.
      } catch (e) {
        // Gérer l'erreur, peut-être réessayer plus tard.
      }
    }
  }
}