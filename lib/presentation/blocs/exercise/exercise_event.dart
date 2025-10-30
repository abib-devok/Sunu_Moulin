part of 'exercise_bloc.dart';

abstract class ExerciseEvent extends Equatable {
  const ExerciseEvent();

  @override
  List<Object> get props => [];
}

/// Événement pour charger les exercices d'un chapitre.
class LoadExercises extends ExerciseEvent {
  final String chapterSlug;

  const LoadExercises(this.chapterSlug);

  @override
  List<Object> get props => [chapterSlug];
}

/// Événement pour soumettre une réponse.
class AnswerSubmitted extends ExerciseEvent {
  final String answer;

  const AnswerSubmitted(this.answer);

  @override
  List<Object> get props => [answer];
}

/// Événement pour passer à l'exercice suivant.
class NextExercise extends ExerciseEvent {}