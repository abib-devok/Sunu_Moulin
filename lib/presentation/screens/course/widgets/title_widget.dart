import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matheasy_sn/domain/entities/course_content/course_content.dart';

class TitleWidget extends StatelessWidget {
  final TitleContent content;
  const TitleWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    double fontSize = content.level == 1 ? 22 : 18;
    FontWeight fontWeight =
        content.level == 1 ? FontWeight.bold : FontWeight.w600;
    return Text(
      content.text,
      style: GoogleFonts.nunito(fontSize: fontSize, fontWeight: fontWeight),
    );
  }
}
