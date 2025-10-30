import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:matheasy_sn/domain/entities/exercise.dart';
import 'package:matheasy_sn/domain/usecases/exercise/get_exercises_usecase.dart';

part 'exercise_event.dart';
part 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final GetExercisesUseCase getExercisesUseCase;

  ExerciseBloc({required this.getExercisesUseCase}) : super(const ExerciseState()) {
    on<LoadExercises>(_onLoadExercises);
    on<AnswerSubmitted>(_onAnswerSubmitted);
    on<NextExercise>(_onNextExercise);
  }

  Future<void> _onLoadExercises(
    LoadExercises event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(state.copyWith(status: ExerciseStatus.loading));
    try {
      final exercises = await getExercisesUseCase(event.chapterSlug);
      if (exercises.isEmpty) {
        emit(state.copyWith(status: ExerciseStatus.loaded, errorMessage: 'Aucun exercice trouvé pour ce chapitre.'));
      } else {
        emit(state.copyWith(status: ExerciseStatus.loaded, exercises: exercises));
      }
    } catch (e) {
      emit(state.copyWith(status: ExerciseStatus.loaded, errorMessage: e.toString()));
    }
  }

  void _onAnswerSubmitted(
    AnswerSubmitted event,
    Emitter<ExerciseState> emit,
  ) {
    final currentExercise = state.exercises[state.currentExerciseIndex];
    final isCorrect = event.answer.toLowerCase() == currentExercise.correctAnswer.toLowerCase();

    emit(state.copyWith(
      status: ExerciseStatus.answered,
      userAnswer: event.answer,
      isCorrect: isCorrect,
      score: isCorrect ? state.score + 1 : state.score,
    ));
  }

  void _onNextExercise(
    NextExercise event,
    Emitter<ExerciseState> emit,
  ) {
    if (state.currentExerciseIndex < state.exercises.length - 1) {
      emit(state.copyWith(
        status: ExerciseStatus.loaded,
        currentExerciseIndex: state.currentExerciseIndex + 1,
        clearAnswer: true,
      ));
    } else {
      emit(state.copyWith(status: ExerciseStatus.completed));
    }
  }
}