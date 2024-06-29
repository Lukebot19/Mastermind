import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mastermind/bloc/game_bloc.dart';
import 'package:mastermind/enums/guesser.dart';
import 'package:mastermind/enums/mode.dart';
import 'package:mastermind/pages/game.dart';

class ColorLockPage extends StatefulWidget {
  @override
  _ColorLockPageState createState() => _ColorLockPageState();
}

class _ColorLockPageState extends State<ColorLockPage> {
  List<int> selectedPositions = [2, 2, 2, 2];
  final List<Color> colorPalette = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
  ];
  final List<ScrollController> controllers = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameBloc, GameState>(
      listener: (context, state) {
        if (state.solutionSet == true) {
          context.read<GameBloc>().add(SetSolutionSet(false));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => GamePage(mode: state.mode)));
        }
      },
      child: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state.mode == GameMode.local)
                  Text(
                    state.guesser == Guesser.player2
                        ? 'Player 1, set your code'
                        : 'Player 2, set your code',
                    style: TextStyle(fontSize: 16),
                  ),
                if (state.mode == GameMode.computer)
                  Text(
                    'Set your code',
                    style: TextStyle(fontSize: 16),
                  ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      List.generate(4, (index) => buildColorSelector(index)),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (state.mode == GameMode.computer) {
                        context
                            .read<GameBloc>()
                            .add(SetCode(selectedPositions));
                        Navigator.pop(context);
                        context.read<GameBloc>().add(ComputerTurnEvent());
                      } else if (state.mode == GameMode.local) {
                        context
                            .read<GameBloc>()
                            .add(SetCode(selectedPositions));
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildColorSelector(int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_upward),
          onPressed: () => changeColor(index, true),
        ),
        CircleAvatar(
          backgroundColor: colorPalette[selectedPositions[index]],
        ),
        IconButton(
          icon: Icon(Icons.arrow_downward),
          onPressed: () => changeColor(index, false),
        ),
      ],
    );
  }

  void changeColor(int index, bool isIncrement) {
    setState(() {
      if (isIncrement) {
        selectedPositions[index] =
            (selectedPositions[index] + 1) % colorPalette.length;
      } else {
        selectedPositions[index] =
            (selectedPositions[index] - 1 + colorPalette.length) %
                colorPalette.length;
      }
    });
  }
}
