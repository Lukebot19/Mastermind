import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mastermind/bloc/game_bloc.dart';
import 'package:mastermind/enums/guesser.dart';
import 'package:mastermind/enums/mode.dart';
import 'package:mastermind/pages/choose_code.dart';
import 'package:mastermind/pages/mode_selection.dart';

class GamePage extends StatefulWidget {
  final GameMode mode;

  const GamePage({Key? key, required this.mode}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final List<Color> colorPalette = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
  ];

  final List<Color> feedbackColours = [
    Colors.black,
    Colors.white,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameBloc, GameState>(
      listener: (context, state) {
        if (state.switchPlayers) {
          // Reset the switchPlayers flag
          context.read<GameBloc>().add(SetSwitchPlayers());
          // Show a dialog to show the scores and switch players
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Correct!'),
                content: Text('You got it in ${state.player1Score} moves'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ColorLockPage()),
                      ).then((value) {
                        // Schedule the ComputerTurnEvent to be dispatched after the widget build is complete
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          context.read<GameBloc>().add(ComputerTurnEvent());
                        });
                      });
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (state.gameOver == true) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Game Over'),
                content: Text(
                    'Player 1: ${state.player1Score}\nPlayer 2: ${state.player2Score}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ModeSelectionPage()));
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
      child: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.grey,
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color.fromRGBO(109, 148, 227, 1),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.guesses.length +
                              1, // +1 for the current guess
                          itemBuilder: (context, index) {
                            if (index < state.guesses.length) {
                              // Display previous guesses and feedback
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(index.toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 26)),
                                        SizedBox(width: 10),
                                        ...state.guesses[index].map(
                                          (colorIndex) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors
                                                      .black, // Set your desired border color here
                                                  width:
                                                      2, // Set your desired border width here
                                                ),
                                              ),
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    colorPalette[colorIndex],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        SizedBox(
                                          // Add a SizedBox to provide bounded constraints
                                          height: 40, // Keep the height as is
                                          width:
                                              72, // Specify the width, adjust this value as needed
                                          child: GridView.count(
                                            crossAxisCount: 2,
                                            childAspectRatio:
                                                2, // Adjusted to make the height half of the width
                                            mainAxisSpacing:
                                                4, // Spacing between rows
                                            crossAxisSpacing:
                                                1, // Spacing between columns
                                            physics:
                                                NeverScrollableScrollPhysics(), // To disable GridView's scrolling
                                            children: state.feedback[index]
                                                .map((f) => Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors
                                                              .black, // Set your desired border color here
                                                          width:
                                                              2, // Set your desired border width here
                                                        ),
                                                        color: f == 2
                                                            ? Colors.black
                                                            : (f == 1
                                                                ? Colors.white
                                                                : Colors.grey),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ))
                                                .toList(), // Convert the iterable to a list for the GridView
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 5,
                                  )
                                ],
                              );
                            } else {
                              // Display the current guess input
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(index.toString(),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 26)),
                                    SizedBox(
                                        width:
                                            10), // Add some spacing between the index and the guess
                                    ...List.generate(
                                      4,
                                      (i) => Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors
                                                .black, // Set your desired border color here
                                            width:
                                                2, // Set your desired border width here
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: CircleAvatar(
                                            backgroundColor: i <
                                                        state.currentGuess
                                                            .length &&
                                                    state.currentGuess[i] != -1
                                                ? colorPalette[
                                                    state.currentGuess[i]]
                                                : Colors
                                                    .grey, // Use grey if the colour is removed or not yet guessed
                                            child: GestureDetector(
                                              onTap: () {
                                                // Tapping removes the color from the guess
                                                context.read<GameBloc>().add(
                                                    RemoveColourFromGuess(i));
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 82),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      if (state.guesser == Guesser.player2 &&
                          state.mode != GameMode.computer)
                        Container(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: feedbackColours.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  context
                                      .read<GameBloc>()
                                      .add(AddColourToFeedback(index));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundColor: feedbackColours[index],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      if (state.guesser == Guesser.player1)
                        Container(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: colorPalette.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  context
                                      .read<GameBloc>()
                                      .add(AddColourToGuess(index));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundColor: colorPalette[index],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      if (state.mode != GameMode.computer &&
                          state.guesser == Guesser.player1)
                        ElevatedButton(
                            onPressed: () {
                              context.read<GameBloc>().add(SubmitGuess());
                            },
                            child: Text('Confirm Guess')),
                      if (state.mode != GameMode.computer &&
                          state.guesser == Guesser.player2)
                        ElevatedButton(
                            onPressed: () {
                              context.read<GameBloc>().add(SubmitGuess());
                            },
                            child: Text('Confirm Feeback')),
                      if (state.mode == GameMode.computer &&
                          state.guesser == Guesser.player1)
                        ElevatedButton(
                          onPressed: () {
                            context.read<GameBloc>().add(SubmitGuess());
                          },
                          child: Text('Confirm Guess'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
