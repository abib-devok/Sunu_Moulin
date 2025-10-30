part of 'progress_bloc.dart';

enum ProgressStatus { initial, loading, loaded, error }

class ProgressState extends Equatable {
  final ProgressStatus status;
  final List<UserProgress> allProgress;
  final String? errorMessage;

  const ProgressState({
    this.status = ProgressStatus.initial,
    this.allProgress = const [],
    this.errorMessage,
  });

  // Logique de calcul pour les statistiques
  int get totalScore {
    if (allProgress.isEmpty) return 0;
    return allProgress.map((p) => p.score).reduce((a, b) => a + b);
  }

  int get totalPossibleScore {
    if (allProgress.isEmpty) return 0;
    return allProgress.map((p) => p.total).reduce((a, b) => a + b);
  }

  double get globalScorePercentage {
    if (totalPossibleScore == 0) return 0.0;
    return (totalScore / totalPossibleScore) * 100;
  }

  int get completedChapters {
    // Un chapitre est "terminé" si au moins un exercice a été fait.
    // On pourrait affiner cette logique.
    return allProgress.map((p) => p.entityId).toSet().length;
  }

  ProgressState copyWith({
    ProgressStatus? status,
    List<UserProgress>? allProgress,
    String? errorMessage,
  }) {
    return ProgressState(
      status: status ?? this.status,
      allProgress: allProgress ?? this.allProgress,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, allProgress, errorMessage];
}