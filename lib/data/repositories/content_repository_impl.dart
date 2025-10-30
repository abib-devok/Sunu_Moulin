import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:matheasy_sn/data/datasources/local/database_service.dart';
import 'package:matheasy_sn/data/models/chapter_model.dart';
import 'package:matheasy_sn/domain/repositories/content_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContentRepositoryImpl implements ContentRepository {
  final SupabaseClient supabaseClient;
  final DatabaseService databaseService;
  final Box<ChapterModel> chaptersBox;

  ContentRepositoryImpl({
    required this.supabaseClient,
    required this.databaseService,
    required this.chaptersBox,
  });

  @override
  Future<void> fetchAndStoreChapters() async {
    try {
      final response = await supabaseClient.from('chapters').select();

      final List<ChapterModel> chapters = (response as List)
          .map((data) => ChapterModel.fromJson(data))
          .toList();

      await chaptersBox.clear();
      for (final chapter in chapters) {
        await chaptersBox.put(chapter.slug, chapter);
      }
    } catch (e) {
      throw Exception('Erreur lors du téléchargement des chapitres: $e');
    }
  }

  @override
  Future<void> fetchAndStoreExercises() async {
     try {
      final response = await supabaseClient.from('exercises').select();

      final List<Map<String, dynamic>> exercises = (response as List).map((data) {
        // SQLite ne supporte pas directement les listes, on encode les options en JSON
        return {
          'id': data['id'],
          'chapterSlug': data['chapter_slug'],
          'question': data['question'],
          'exercise_type': data['exercise_type'],
          'options': data['options'] != null ? jsonEncode(data['options']) : null,
          'correctAnswer': data['correct_answer'],
        };
      }).toList();

      await databaseService.insertExercises(exercises);
    } catch (e) {
      throw Exception('Erreur lors du téléchargement des exercices: $e');
    }
  }
}