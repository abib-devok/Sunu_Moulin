import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matheasy_sn/domain/entities/course_content/course_content.dart';

class ParagraphWidget extends StatelessWidget {
  final ParagraphContent content;
  const ParagraphWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(
      content.text,
      style: GoogleFonts.nunito(fontSize: 16, height: 1.5),
    );
  }
}
