import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mastermind/bloc/game_bloc.dart';

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
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    List.generate(4, (index) => buildColorSelector(index)),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    context.read<GameBloc>().add(SetCode(selectedPositions));
                    Navigator.pop(context);
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        );
      },
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
