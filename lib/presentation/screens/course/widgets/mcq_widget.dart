import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matheasy_sn/domain/entities/course_content/course_content.dart';

class McqWidget extends StatefulWidget {
  final McqContent content;
  final int contentIndex;
  final Function(int, int?) onAnswerChanged;
  final int? groupValue;

  const McqWidget({
    super.key,
    required this.content,
    required this.contentIndex,
    required this.onAnswerChanged,
    required this.groupValue,
  });

  @override
  State<McqWidget> createState() => _McqWidgetState();
}

class _McqWidgetState extends State<McqWidget> {
  @override
  Widget build(BuildContext context) {
    const Color secondaryColor = Color(0xFF1E88E5);
    const Color successColor = Color(0xFF4CAF50);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: secondaryColor.withAlpha(128), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.content.question,
                style: GoogleFonts.nunito(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...widget.content.options.asMap().entries.map((entry) {
              int idx = entry.key;
              String text = entry.value;
              return ListTile(
                title: Text(text, style: GoogleFonts.nunito()),
                leading: Radio<int>(
                  value: idx,
                  groupValue: widget.groupValue,
                  onChanged: (int? value) {
                    widget.onAnswerChanged(widget.contentIndex, value);
                  },
                  activeColor: successColor,
                ),
                onTap: () {
                  widget.onAnswerChanged(widget.contentIndex, idx);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
