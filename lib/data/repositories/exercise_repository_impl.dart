import 'dart:convert';
import 'package:matheasy_sn/data/datasources/local/database_service.dart';
import 'package:matheasy_sn/domain/entities/exercise.dart';
import 'package:matheasy_sn/domain/repositories/exercise_repository.dart';

/// Implémentation du `ExerciseRepository`.
class ExerciseRepositoryImpl implements ExerciseRepository {
  final DatabaseService databaseService;

  ExerciseRepositoryImpl({required this.databaseService});

  @override
  Future<List<Exercise>> getExercisesForChapter(String chapterSlug) async {
    final List<Map<String, dynamic>> maps =
        await databaseService.getExercisesForChapter(chapterSlug);

    // Données factices si la base de données est vide
    if (maps.isEmpty) {
      return _getFakeExercises(chapterSlug);
    }

    return List.generate(maps.length, (i) {
      final map = maps[i];
      return Exercise(
        id: map['id'],
        chapterSlug: map['chapterSlug'],
        question: map['question'],
        type: _stringToExerciseType(map['type']),
        options: map['options'] != null ? List<String>.from(jsonDecode(map['options'])) : null,
        correctAnswer: map['correctAnswer'],
      );
    });
  }

  ExerciseType _stringToExerciseType(String type) {
    switch (type) {
      case 'qcm':
        return ExerciseType.qcm;
      case 'input':
        return ExerciseType.input;
      case 'trueFalse':
        return ExerciseType.trueFalse;
      default:
        return ExerciseType.input;
    }
  }

  // Méthode pour fournir des données factices en attendant la synchronisation
  List<Exercise> _getFakeExercises(String chapterSlug) {
    return [
      const Exercise(
        id: '1',
        chapterSlug: 'racine-carree',
        question: 'Calcule : √49',
        type: ExerciseType.input,
        correctAnswer: '7',
      ),
      const Exercise(
        id: '2',
        chapterSlug: 'racine-carree',
        question: 'Calcule : √81',
        type: ExerciseType.input,
        correctAnswer: '9',
      ),
      const Exercise(
        id: '3',
        chapterSlug: 'racine-carree',
        question: '√16 est égal à 4.',
        type: ExerciseType.trueFalse,
        correctAnswer: 'Vrai',
      ),
       const Exercise(
        id: '4',
        chapterSlug: 'racine-carree',
        question: 'Quelle est la racine carrée de 144 ?',
        type: ExerciseType.qcm,
        options: ['10', '12', '14'],
        correctAnswer: '12',
      ),
    ];
  }
}