import 'package:flutter/material.dart';
import 'package:mastermind/bloc/game_bloc.dart';
import 'package:mastermind/enums/mode.dart';
import 'package:mastermind/pages/choose_code.dart';
import 'package:mastermind/pages/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModeSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Game Mode'),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => {
                context.read<GameBloc>().add(StartGame(GameMode.computer)),
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => GamePage(mode: GameMode.computer)))
              },
              child: Text('Play Against Computer'),
            ),
            ElevatedButton(
              onPressed: () => {
                context.read<GameBloc>().add(StartGame(GameMode.local)),
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ColorLockPage())),
              },
              child: Text('Play Locally'),
            ),
            ElevatedButton(
              onPressed: () => {
                context.read<GameBloc>().add(StartGame(GameMode.online)),
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Coming Soon'),
                        content: Text('Online mode is not yet available'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    }),
              },
              child: Text('Play Online'),
            ),
          ],
        ),
      ),
    );
  }
}
