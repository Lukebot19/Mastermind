import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mastermind/bloc/game_bloc.dart';
import 'package:mastermind/pages/choose_code.dart';

import 'package:mastermind/pages/mode_selection.dart';

void main() {
  runApp(const MastermindApp());
}

class MastermindApp extends StatelessWidget {
  const MastermindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ModeSelectionPage(),
      ),
    );
  }
}
