import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:matheasy_sn/domain/repositories/content_repository.dart';

part 'content_event.dart';
part 'content_state.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final ContentRepository contentRepository;

  ContentBloc({required this.contentRepository}) : super(const ContentState()) {
    on<DownloadInitialContent>(_onDownloadInitialContent);
  }

  Future<void> _onDownloadInitialContent(
    DownloadInitialContent event,
    Emitter<ContentState> emit,
  ) async {
    emit(state.copyWith(status: ContentStatus.downloading, progress: 0.1, message: 'Téléchargement des chapitres...'));
    try {
      await contentRepository.fetchAndStoreChapters();
      emit(state.copyWith(progress: 0.5, message: 'Téléchargement des exercices...'));

      await contentRepository.fetchAndStoreExercises();
      emit(state.copyWith(progress: 1.0, message: 'Contenu téléchargé avec succès !', status: ContentStatus.success));

    } catch (e) {
      emit(state.copyWith(status: ContentStatus.failure, error: e.toString()));
    }
  }
}