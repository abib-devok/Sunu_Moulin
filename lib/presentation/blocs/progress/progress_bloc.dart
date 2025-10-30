import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:matheasy_sn/domain/entities/user_progress.dart';
import 'package:matheasy_sn/domain/usecases/progress/get_progress_usecase.dart';
import 'package:matheasy_sn/domain/usecases/progress/save_progress_usecase.dart';

part 'progress_event.dart';
part 'progress_state.dart';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final GetProgressUseCase getProgressUseCase;
  final SaveProgressUseCase saveProgressUseCase;

  ProgressBloc({
    required this.getProgressUseCase,
    required this.saveProgressUseCase,
  }) : super(const ProgressState()) {
    on<LoadProgress>(_onLoadProgress);
    on<AddProgress>(_onAddProgress);
  }

  Future<void> _onLoadProgress(
    LoadProgress event,
    Emitter<ProgressState> emit,
  ) async {
    emit(state.copyWith(status: ProgressStatus.loading));
    try {
      final progressList = await getProgressUseCase();
      emit(state.copyWith(
        status: ProgressStatus.loaded,
        allProgress: progressList,
      ));
    } catch (e) {
      emit(state.copyWith(status: ProgressStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onAddProgress(
    AddProgress event,
    Emitter<ProgressState> emit,
  ) async {
    try {
      await saveProgressUseCase(event.progress);
      // Après avoir sauvegardé, on recharge les données pour mettre à jour l'état
      add(LoadProgress());
    } catch (e) {
      emit(state.copyWith(status: ProgressStatus.error, errorMessage: e.toString()));
    }
  }
}