part of 'content_bloc.dart';

enum ContentStatus { initial, downloading, success, failure }

class ContentState extends Equatable {
  final ContentStatus status;
  final double progress;
  final String message;
  final String? error;

  const ContentState({
    this.status = ContentStatus.initial,
    this.progress = 0.0,
    this.message = 'Prêt à commencer',
    this.error,
  });

  ContentState copyWith({
    ContentStatus? status,
    double? progress,
    String? message,
    String? error,
  }) {
    return ContentState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, progress, message, error];
}