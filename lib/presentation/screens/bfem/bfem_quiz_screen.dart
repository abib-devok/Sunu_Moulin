import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Écran pour le quiz chronométré des épreuves du BFEM.
class BfemQuizScreen extends StatefulWidget {
  final int year;
  const BfemQuizScreen({super.key, required this.year});

  @override
  State<BfemQuizScreen> createState() => _BfemQuizScreenState();
}

class _BfemQuizScreenState extends State<BfemQuizScreen> {
  late Timer _timer;
  int _start = 90 * 60; // 90 minutes en secondes

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            // TODO: Gérer la fin du temps
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _timerString {
    final duration = Duration(seconds: _start);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz BFEM ${widget.year}'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                _timerString,
                style: GoogleFonts.lexend(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: _start < 600 ? Colors.red : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text('Le contenu du quiz apparaîtra ici.'),
      ),
    );
  }
}