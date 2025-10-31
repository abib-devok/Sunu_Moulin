import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:matheasy_sn/domain/entities/course_content/course_content.dart';

class MathFormulaWidget extends StatelessWidget {
  final MathFormulaContent content;
  const MathFormulaWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Math.tex(
        content.texExpression,
        textStyle: const TextStyle(fontSize: 18),
      ),
    );
  }
}
