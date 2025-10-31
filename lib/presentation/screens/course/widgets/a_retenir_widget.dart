import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matheasy_sn/domain/entities/course_content/course_content.dart';

class ARetenirWidget extends StatelessWidget {
  final ARetenirContent content;
  final Widget Function(CourseContent, int) buildContentItem;

  const ARetenirWidget({
    super.key,
    required this.content,
    required this.buildContentItem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.orange.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.orange.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content.title,
              style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800),
            ),
            const Divider(height: 24),
            ...content.content
                .map((item) => buildContentItem(item, -1))
                .toList(),
          ],
        ),
      ),
    );
  }
}
