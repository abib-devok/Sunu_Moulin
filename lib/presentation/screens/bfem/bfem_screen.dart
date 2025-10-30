import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Modèle simple pour représenter une épreuve du BFEM.
class BfemExam {
  final int year;
  final double sizeMb;
  final bool isDownloaded;

  BfemExam({required this.year, required this.sizeMb, this.isDownloaded = false});
}

/// Écran affichant la liste des épreuves du BFEM disponibles.
class BfemScreen extends StatefulWidget {
  const BfemScreen({super.key});

  @override
  State<BfemScreen> createState() => _BfemScreenState();
}

class _BfemScreenState extends State<BfemScreen> {
  // Données factices des épreuves
  final List<BfemExam> _exams = [
    BfemExam(year: 2024, sizeMb: 12.5),
    BfemExam(year: 2023, sizeMb: 11.8, isDownloaded: true),
    BfemExam(year: 2022, sizeMb: 13.1),
    BfemExam(year: 2021, sizeMb: 10.5),
    BfemExam(year: 2020, sizeMb: 9.8, isDownloaded: true),
  ];

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
              context.go('/home'); // Assurez-vous que AppRouter.home est accessible ou utilisez le chemin direct
            }
          },
        ),
        title: Text(
          'Épreuves BFEM',
          style: GoogleFonts.lexend(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _exams.length,
        itemBuilder: (context, index) {
          final exam = _exams[index];
          return _buildExamCard(context, exam, primaryColor);
        },
      ),
    );
  }

  /// Construit une carte pour une épreuve du BFEM.
  Widget _buildExamCard(BuildContext context, BfemExam exam, Color primaryColor) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BFEM Mathématiques - Année ${exam.year}',
              style: GoogleFonts.lexend(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pack complet (Sujet PDF + Quiz interactif)',
              style: GoogleFonts.nunito(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            if (exam.isDownloaded)
              _buildDownloadedButtons(context, exam, primaryColor)
            else
              _buildDownloadButton(exam, primaryColor),
          ],
        ),
      ),
    );
  }

  /// Construit le bouton de téléchargement pour une épreuve non téléchargée.
  Widget _buildDownloadButton(BfemExam exam, Color primaryColor) {
    return ElevatedButton.icon(
      onPressed: () {
        // TODO: Implémenter la logique de téléchargement
      },
      icon: const Icon(Icons.download_for_offline_outlined),
      label: Text('Télécharger (${exam.sizeMb} Mo)'),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Construit les boutons d'action pour une épreuve déjà téléchargée.
  Widget _buildDownloadedButtons(BuildContext context, BfemExam exam, Color primaryColor) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // Simule la navigation vers un PDF téléchargé
              // En réalité, ce chemin viendrait d'un service qui gère les fichiers téléchargés
              const fakePdfPath = '/data/user/0/com.example.matheasy_sn/files/bfem_2023.pdf';
              context.goNamed(
                'pdf-viewer',
                queryParameters: {'filePath': fakePdfPath, 'title': 'BFEM ${exam.year}'},
              );
            },
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: const Text('Lire'),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: BorderSide(color: primaryColor),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              context.goNamed('bfem-quiz', pathParameters: {'year': exam.year.toString()});
            },
            icon: const Icon(Icons.quiz_outlined),
            label: const Text('Faire le Quiz'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE85A24),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}