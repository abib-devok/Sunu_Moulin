part of 'exercise_bloc.dart';

/// Statut de la session d'exercices.
enum ExerciseStatus { initial, loading, loaded, answered, completed }

class ExerciseState extends Equatable {
  final ExerciseStatus status;
  final List<Exercise> exercises;
  final int currentExerciseIndex;
  final int score;
  final String? userAnswer;
  final bool? isCorrect;
  final String? errorMessage;

  const ExerciseState({
    this.status = ExerciseStatus.initial,
    this.exercises = const [],
    this.currentExerciseIndex = 0,
    this.score = 0,
    this.userAnswer,
    this.isCorrect,
    this.errorMessage,
  });

  /// Crée une copie de l'état avec des valeurs mises à jour.
  ExerciseState copyWith({
    ExerciseStatus? status,
    List<Exercise>? exercises,
    int? currentExerciseIndex,
    int? score,
    String? userAnswer,
    bool? isCorrect,
    String? errorMessage,
    bool clearAnswer = false,
  }) {
    return ExerciseState(
      status: status ?? this.status,
      exercises: exercises ?? this.exercises,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      score: score ?? this.score,
      userAnswer: clearAnswer ? null : userAnswer ?? this.userAnswer,
      isCorrect: clearAnswer ? null : isCorrect ?? this.isCorrect,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        exercises,
        currentExerciseIndex,
        score,
        userAnswer,
        isCorrect,
        errorMessage,
      ];
}