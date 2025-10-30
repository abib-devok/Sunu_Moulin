part of 'content_bloc.dart';

abstract class ContentEvent extends Equatable {
  const ContentEvent();

  @override
  List<Object> get props => [];
}

/// Événement pour démarrer le téléchargement de tout le contenu initial.
class DownloadInitialContent extends ContentEvent {}