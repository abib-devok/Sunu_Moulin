import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matheasy_sn/app/di/injector.dart';
import 'package:matheasy_sn/presentation/blocs/progress/progress_bloc.dart';

/// Écran conteneur qui fournit le BLoC à l'écran de progression.
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProgressBloc>()..add(LoadProgress()),
      child: const ProgressView(),
    );
  }
}

/// Vue affichant les progrès de l'utilisateur.
class ProgressView extends StatelessWidget {
  const ProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF003366);
    const Color backgroundColor = Color(0xFFF5F7F8);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Text(
          'Mes Progrès',
          style: GoogleFonts.lexend(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ProgressBloc, ProgressState>(
        builder: (context, state) {
          if (state.status == ProgressStatus.loading || state.status == ProgressStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ProgressStatus.error) {
            return Center(child: Text(state.errorMessage ?? 'Erreur de chargement'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildOverallScoreCard(primaryColor, state),
                const SizedBox(height: 16),
                _buildStatsGrid(state),
                const SizedBox(height: 16),
                _buildChartCard(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverallScoreCard(Color primaryColor, ProgressState state) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Score Global',
                  style: GoogleFonts.lexend(color: Colors.white.withAlpha(204), fontSize: 16),
                ),
                Text(
                  '${state.globalScorePercentage.toStringAsFixed(0)}%',
                  style: GoogleFonts.lexend(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Icon(Icons.show_chart, color: Colors.white, size: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(ProgressState state) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard('Chapitres terminés', '${state.completedChapters} / 13', Icons.library_books_outlined),
        _buildStatCard('Activités Numériques', '68%', Icons.calculate_outlined), // Donnée factice
        _buildStatCard('Activités Géométriques', '76%', Icons.architecture_outlined), // Donnée factice
        _buildStatCard('Dernier quiz (2024)', '15/20', Icons.quiz_outlined), // Donnée factice
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.grey.shade600, size: 28),
            const Spacer(),
            Text(title, style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey.shade700)),
            Text(value, style: GoogleFonts.lexend(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Progression sur 7 jours', style: GoogleFonts.lexend(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              height: 150,
              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.bar_chart, size: 40, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text('Graphique à venir', style: GoogleFonts.nunito(color: Colors.grey.shade700)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}