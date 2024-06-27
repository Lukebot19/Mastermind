import 'package:flutter/material.dart';
import 'package:mastermind/enums/mode.dart';
import 'package:mastermind/pages/game.dart';

class ModeSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Game Mode')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => GamePage(mode: GameMode.computer))),
            child: Text('Play Against Computer'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => GamePage(mode: GameMode.local))),
            child: Text('Play Locally'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => GamePage(mode: GameMode.online))),
            child: Text('Play Online'),
          ),
        ],
      ),
    );
  }
}
