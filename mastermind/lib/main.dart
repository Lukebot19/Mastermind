import 'package:flutter/material.dart';

import 'package:mastermind/pages/mode_selection.dart';

void main() {
  runApp(const MastermindApp());
}

class MastermindApp extends StatelessWidget {
  const MastermindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ModeSelectionPage(),
    );
  }
}
