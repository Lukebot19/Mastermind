import 'package:flutter/material.dart';
import 'package:mastermind/enums/mode.dart';

class GamePage extends StatefulWidget {
  final GameMode mode;

  const GamePage({Key? key, required this.mode}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();


}

class _GamePageState extends State<GamePage> {
  List<List<int>> guesses = []; // Each guess is a list of color indices
  List<int> currentGuess = []; // Current guess being input by the user
  List<List<int>> feedback =
      []; // Feedback for each guess (0: wrong, 1: right color wrong place, 2: right color right place)

  final List<Color> colorPalette = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
  ];

  void addGuess() {
    if (currentGuess.length == 4) {
      // Ensure the guess is complete
      setState(() {
        guesses.add(List.from(currentGuess));
        currentGuess.clear();
        // Here, you would also calculate the feedback for the guess and add it to the feedback list
        // For now, we'll just add dummy feedback
        feedback.add([0, 1, 2, 1]); // Dummy feedback, replace with actual logic
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mastermind'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: guesses.length + 1, // +1 for the current guess
              itemBuilder: (context, index) {
                if (index < guesses.length) {
                  // Display previous guesses and feedback
                  return Row(
                    children: [
                      ...guesses[index].map((colorIndex) => CircleAvatar(
                          backgroundColor: colorPalette[colorIndex])),
                      SizedBox(width: 10),
                      ...feedback[index].map((f) => Icon(
                          f == 2
                              ? Icons.check
                              : (f == 1 ? Icons.swap_horiz : Icons.close),
                          size: 16)),
                    ],
                  );
                } else {
                  // Display the current guess input
                  return Row(
                    children: [
                      ...List.generate(
                          4,
                          (i) => CircleAvatar(
                                backgroundColor: i < currentGuess.length
                                    ? colorPalette[currentGuess[i]]
                                    : Colors.grey,
                                child: GestureDetector(
                                  onTap: () {
                                    // Allow tapping on the current guess to change colors
                                  },
                                ),
                              )),
                    ],
                  );
                }
              },
            ),
          ),
          Container(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: colorPalette.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (currentGuess.length < 4) {
                      setState(() {
                        currentGuess.add(index);
                      });
                    }
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
          ElevatedButton(
            onPressed: addGuess,
            child: Text('Confirm Guess'),
          ),
        ],
      ),
    );
  }
}
