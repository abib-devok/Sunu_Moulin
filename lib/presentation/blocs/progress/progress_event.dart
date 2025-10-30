part of 'progress_bloc.dart';

abstract class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object> get props => [];
}

/// Événement pour charger les données de progression de l'utilisateur.
class LoadProgress extends ProgressEvent {}

/// Événement pour ajouter une nouvelle entrée de progression.
/// Cet événement serait déclenché à la fin d'une session d'exercices ou d'un quiz.
class AddProgress extends ProgressEvent {
  final UserProgress progress;

  const AddProgress(this.progress);

  @override
  List<Object> get props => [progress];
}