import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';

/// Écran pour afficher un document PDF.
///
/// Utilise le package `syncfusion_flutter_pdfviewer` pour afficher le PDF
/// à partir d'un chemin de fichier local.
class PdfViewerScreen extends StatelessWidget {
  final String filePath;
  final String title;

  const PdfViewerScreen({super.key, required this.filePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.lexend(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SfPdfViewer.file(
        File(filePath),
        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
          // Gérer l'erreur, par exemple en affichant un message à l'utilisateur
        },
      ),
    );
  }
}