import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matheasy_sn/app/di/injector.dart';
import 'package:matheasy_sn/domain/entities/exercise.dart';
import 'package:matheasy_sn/presentation/blocs/exercise/exercise_bloc.dart';

/// Écran conteneur qui fournit le BLoC à l'écran d'exercices.
class ExercisesScreen extends StatelessWidget {
  final String chapterSlug;
  const ExercisesScreen({super.key, required this.chapterSlug});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ExerciseBloc>()..add(LoadExercises(chapterSlug)),
      child: const ExercisesView(),
    );
  }
}

/// Vue principale pour réaliser une série d'exercices.
class ExercisesView extends StatefulWidget {
  const ExercisesView({super.key});

  @override
  State<ExercisesView> createState() => _ExercisesViewState();
}

class _ExercisesViewState extends State<ExercisesView> {
  final TextEditingController _answerController = TextEditingController();

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7F8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Exercices', // Titre dynamique ?
          style: GoogleFonts.lexend(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ExerciseBloc, ExerciseState>(
        builder: (context, state) {
          if (state.status == ExerciseStatus.loading || state.status == ExerciseStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.exercises.isEmpty) {
            return const Center(child: Text('Aucun exercice disponible.'));
          }

          if (state.status == ExerciseStatus.completed) {
            return _buildCompletionScreen(state.score, state.exercises.length);
          }

          final currentExercise = state.exercises[state.currentExerciseIndex];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: _buildExerciseContent(context, state, currentExercise),
          );
        },
      ),
    );
  }

  Widget _buildExerciseContent(BuildContext context, ExerciseState state, Exercise exercise) {
    final bool isAnswered = state.status == ExerciseStatus.answered;
    const Color primaryColor = Color(0xFF003366);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Exercice ${state.currentExerciseIndex + 1}/${state.exercises.length}',
          textAlign: TextAlign.center,
          style: GoogleFonts.lexend(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (state.currentExerciseIndex + 1) / state.exercises.length,
          backgroundColor: Colors.grey,
          valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
        ),
        const SizedBox(height: 48),
        Text(
          exercise.question,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),

        _buildAnswerWidget(exercise, isAnswered),

        const SizedBox(height: 32),
        if (isAnswered)
          _buildFeedbackCard(
            isCorrect: state.isCorrect!,
            correctAnswer: exercise.correctAnswer,
            explanation: 'Explication à ajouter ici.',
          ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            if (isAnswered) {
              context.read<ExerciseBloc>().add(NextExercise());
            } else {
              context.read<ExerciseBloc>().add(AnswerSubmitted(_answerController.text));
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Text(
            isAnswered ? 'SUIVANT' : 'VÉRIFIER',
            style: GoogleFonts.lexend(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerWidget(Exercise exercise, bool isAnswered) {
    switch (exercise.type) {
      case ExerciseType.input:
        return TextField(
          controller: _answerController,
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          style: GoogleFonts.lexend(fontSize: 24, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: 'Ta réponse',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
          enabled: !isAnswered,
        );
      case ExerciseType.qcm:
        // TODO: Implémenter la logique pour les QCM
        return const Text('QCM non implémenté');
      case ExerciseType.trueFalse:
        // TODO: Implémenter la logique pour Vrai/Faux
        return const Text('Vrai/Faux non implémenté');
    }
  }

  Widget _buildFeedbackCard({
    required bool isCorrect,
    required String correctAnswer,
    required String explanation,
  }) {
    const Color successColor = Color(0xFF4CAF50);
    const Color errorColor = Color(0xFFD32F2F);
    final color = isCorrect ? successColor : errorColor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'Correct !' : 'Incorrect',
                style: GoogleFonts.lexend(fontSize: 20, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('La bonne réponse est : $correctAnswer', style: GoogleFonts.nunito(fontSize: 16)),
          const SizedBox(height: 4),
          Text(explanation, textAlign: TextAlign.center, style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey.shade700)),
        ],
      ),
    );
  }

  Widget _buildCompletionScreen(int score, int total) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.celebration, color: Colors.amber, size: 100),
          const SizedBox(height: 24),
          Text('Série terminée !', style: GoogleFonts.lexend(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text('Ton score', style: GoogleFonts.nunito(fontSize: 20)),
          Text('$score / $total', style: GoogleFonts.lexend(fontSize: 48, fontWeight: FontWeight.bold, color: const Color(0xFF003366))),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Retourner aux chapitres'),
          ),
        ],
      ),
    );
  }
}