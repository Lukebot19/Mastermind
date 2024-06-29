import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:mastermind/enums/guesser.dart';
import 'package:mastermind/enums/mode.dart';
import 'package:meta/meta.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  List<int> colors = [
    0,
    1,
    2,
    3,
    4
  ]; // Assuming colors are represented by integers 0-4
  GameBloc() : super(GameState()) {
    on<ComputerTurnEvent>((event, emit) async {
      // Implement the logic for the computer's turn
      try {
        var computerGuess = await solveMastermind(emit);
      } catch (e) {
        print(e);
      }

      emit(state.copyWith(gameOver: true));
    });

    on<SetCode>((event, emit) {
      emit(state.copyWith(solution: event.code));
    });

    on<SetSwitchPlayers>((event, emit) {
      emit(state.copyWith(switchPlayers: false));
    });

    on<AddColourToFeedback>((event, emit) {
      List<int> newCurrentFeedback = List.from(state.currentFeedback);
      try {
        int firstBlankIndex =
            newCurrentFeedback.indexOf(-1); // Find the first index of -1
        if (firstBlankIndex != -1) {
          // If found, replace -1 with the new color
          newCurrentFeedback[firstBlankIndex] = event.colorIndex;
        } else if (state.currentGuess.length < 4) {
          // If no -1 found and list is not full, add color to the end
          newCurrentFeedback.add(event.colorIndex);
        } else {
          // List is full and no -1 present, emit error
          return;
        }
      } catch (e) {
        print(e);

        return;
      }

      emit(state.copyWith(currentGuess: newCurrentFeedback));
    });

    on<AddColourToGuess>((event, emit) {
      List<int> newCurrentGuess = List.from(state.currentGuess);
      try {
        int firstBlankIndex =
            newCurrentGuess.indexOf(-1); // Find the first index of -1
        if (firstBlankIndex != -1) {
          // If found, replace -1 with the new color
          newCurrentGuess[firstBlankIndex] = event.colorIndex;
        } else if (state.currentGuess.length < 4) {
          // If no -1 found and list is not full, add color to the end
          newCurrentGuess.add(event.colorIndex);
        } else {
          // List is full and no -1 present, emit error
          return;
        }
      } catch (e) {
        print(e);

        return;
      }

      emit(state.copyWith(currentGuess: newCurrentGuess));
    });

    on<RemoveColourFromGuess>((event, emit) {
      List<int> newCurrentGuess = List.from(state.currentGuess);
      try {
        // Check if the position to remove is valid and not already blank
        if (event.position >= 0 &&
            event.position < newCurrentGuess.length &&
            newCurrentGuess[event.position] != -1) {
          // Blank out the color at the specified position
          newCurrentGuess[event.position] =
              -1; // Assuming -1 represents a blank state
        } else {
          // If the position is already blank or invalid, emit an error message
        }
      } catch (e) {
        print(e);

        return;
      }

      emit(state.copyWith(currentGuess: newCurrentGuess));
    });

    on<SubmitFeedback>((event, emit) {
      if (state.currentFeedback.length == 4) {
        // Ensure the feedback is complete
        List<List<int>> newFeedback = List.from(state.feedback);
        newFeedback.add(List.from(state.currentFeedback));
        emit(state.copyWith(feedback: newFeedback, currentFeedback: []));
      } else {
        // Display an error message or something
      }
    });

    on<SubmitGuess>((event, emit) {
      // Add logic to submit a guess
      List<int> newCurrentGuess = List.from(state.currentGuess);
      List<List<int>> newGuesses = List.from(state.guesses);
      List<List<int>> newFeedback = List.from(state.feedback);

      if (state.currentGuess.length == 4) {
        // Check if the current guess is the solution
        if (newCurrentGuess.join() == state.solution.join()) {
          // Handle the win condition
          Guesser newGuesser;
          int player1Score = 0;
          int player2Score = 0;
          if (state.guesser == Guesser.player1) {
            newGuesser = Guesser.player2;
            player1Score = state.guesses.length;
          } else {
            newGuesser = Guesser.player1;
            player2Score = state.guesses.length;
          }
          emit(state.copyWith(
            guesses: [],
            currentGuess: [],
            feedback: [],
            currentFeedback: [],
            guesser: newGuesser,
            switchPlayers: true,
            player1Score: player1Score,
            player2Score: player2Score,
          ));
          emit(state.copyWith(switchPlayers: false, gameOver: false));

          return;
        }
        // Ensure the guess is complete
        newGuesses.add(List.from(newCurrentGuess));
        newCurrentGuess.clear();
        // Here, you would also calculate the feedback for the guess and add it to the feedback list
        newFeedback.add(calculateFeedback(newGuesses.last, state.solution));
      } else {
        // Display an error message or something
      }
      emit(state.copyWith(
          guesses: newGuesses,
          currentGuess: newCurrentGuess,
          feedback: newFeedback));
    });

    on<ResetGame>((event, emit) {
      // Add logic to reset the game
      emit(GameState());
    });

    on<StartGame>((event, emit) {
      if (event.mode == GameMode.computer) {
        List<int> solution = List.generate(
            4, (index) => Random().nextInt(5)); // Generate a random solution
        emit(state.copyWith(
          solution: solution,
          feedback: [],
          mode: event.mode,
          guesser: Guesser.player1, // Start with player1 as the guesser
        ));
      } else {
        // Handle other modes if necessary
        emit(state.copyWith(mode: event.mode));
      }
    });
  }

  List<int> calculateFeedback(List<int> guess, List<int> solution) {
    List<int> feedback = [];
    List<bool> matched = List<bool>.filled(solution.length, false);

    // First pass: check for correct color and position
    for (int i = 0; i < guess.length; i++) {
      if (guess[i] == solution[i]) {
        feedback.add(2);
        matched[i] = true;
      }
    }

    // Second pass: check for correct color in wrong position
    for (int i = 0; i < guess.length; i++) {
      if (!matched[i] && solution.contains(guess[i])) {
        // Ensure we don't count a peg more than once
        int indexInSolution = solution.indexOf(guess[i]);
        if (!matched[indexInSolution]) {
          feedback.add(1);
          matched[indexInSolution] = true;
        } else {
          // Find next unmatched peg of the same color, if any
          for (int j = indexInSolution + 1; j < solution.length; j++) {
            if (solution[j] == guess[i] && !matched[j]) {
              feedback.add(1);
              matched[j] = true;
              break;
            }
          }
        }
      }
    }

    // Fill in 0s for unmatched pegs
    while (feedback.length < guess.length) {
      feedback.add(0);
    }

    // Randomise the order of the feedback
    // feedback.shuffle();

    return feedback;
  }

  int getRandomInt(int min, int max) {
    var rng = Random();
    return min + rng.nextInt(max - min + 1);
  }

  List<List<int>> combinations = [];
  List<List<int>> candidateSolutions = [];
  List<List<int>> nextGuesses = [];
  List<int> currentGuess = [];
  List<List<int>> currentFeedback = [];
  String responsePegs = '';
  bool won = false;
  int turn = 1;

  Future<void> solveMastermind(Emitter<GameState> emit) async {
    turn = 1;
    won = false;

    // Generate a random solution, a list of 4 numbers ranging from 0 to 4
    currentGuess = List.generate(4, (index) => Random().nextInt(5));

    emit(state.copyWith(currentGuess: List.from(currentGuess)));
    String stringFeedback = checkCode(currentGuess, state.solution);

    try {
      currentFeedback.add(convertFeedback(stringFeedback));
    } catch (e) {
      print(e);
      return;
    }

    await Future.delayed(Duration(milliseconds: 500), () {});

    emit(
      state.copyWith(
        guesses: [currentGuess],
        currentGuess: [],
        feedback: currentFeedback,
      ),
    );

    await Future.delayed(Duration(seconds: 1), () {});

    // Create the set of 1296 possible codes
    createSet();
    candidateSolutions.addAll(combinations);

    while (!won) {
      // Remove currentGuess from possible solutions
      removeCode(combinations, currentGuess);
      removeCode(candidateSolutions, currentGuess);

      // Play the guess to get a response of colored and white pegs
      responsePegs = checkCode(currentGuess, state.solution);

      // If the response is four colored pegs, the game is won
      if (responsePegs == 'BBBB') {
        emit(state.copyWith(
          currentGuess: currentGuess,
          currentFeedback: [2, 2, 2, 2],
          player2Score: turn,
        ));
        won = true;
        print('Game Won!');
        return;
      }

      // Remove from candidateSolutions, any code that would not give the same response if it were the code
      pruneCodes(candidateSolutions, currentGuess, responsePegs);

      // Calculate Minmax scores
      try {
        nextGuesses = minmax();
      } catch (e) {
        print(e);
        return;
      }

      // Select next guess
      currentGuess = getNextGuess(nextGuesses);

      List<List<int>> newGuesses = List.from(state.guesses);
      newGuesses.add(List.from(currentGuess));

      // Play the guess to get a response of colored and white pegs
      responsePegs = checkCode(currentGuess, state.solution);

      currentFeedback.add(convertFeedback(responsePegs));

      emit(state.copyWith(
          guesses: newGuesses, currentGuess: [], feedback: currentFeedback));
      await Future.delayed(Duration(seconds: 1), () {});

      turn++;
    }
  }

  void createSet() {
    List<int> current = List.filled(4, 0);
    List<int> elements = List.generate(5, (i) => i);

    combinationRecursive(4, 0, current, elements);
  }

  void combinationRecursive(int combinationLength, int position,
      List<int> current, List<int> elements) {
    if (position >= combinationLength) {
      combinations.add(List.from(current));
      return;
    }

    for (int j = 0; j < elements.length; j++) {
      current[position] = elements[j];
      combinationRecursive(combinationLength, position + 1, current, elements);
    }
  }

  String checkCode(List<int> guess, List<int> code) {
    String result = '';
    List<int> tempGuess = List.from(guess);
    List<int> tempCode = List.from(code);

    // Get black/colored pegs
    for (int i = 0; i < 4; i++) {
      if (tempGuess[i] == tempCode[i]) {
        result += 'B';
        tempGuess[i] = -1;
        tempCode[i] = -1;
      }
    }

    // Get white pegs
    for (int i = 0; i < 4; i++) {
      if (tempCode[i] > 0) {
        int index = tempGuess.indexOf(tempCode[i]);
        if (index != -1) {
          result += 'W';
          tempGuess[index] = -1;
        }
      }
    }

    return result;
  }

  List<int> convertFeedback(String feedback) {
    try {
      List<int> convertedFeedback = [];
      // for each w add a 1 and for each b add a 2
      for (int i = 0; i < feedback.length; i++) {
        if (feedback[i] == 'W') {
          convertedFeedback.add(1);
        } else if (feedback[i] == 'B') {
          convertedFeedback.add(2);
        }
      }

      // fill to a length of 4
      while (convertedFeedback.length < 4) {
        convertedFeedback.add(0);
      }

      return convertedFeedback;
    } catch (e) {
      print(e);
      return [];
    }
  }

  void removeCode(List<List<int>> set, List<int> currentCode) {
    set.remove(currentCode);
  }

  void pruneCodes(
      List<List<int>> set, List<int> currentCode, String currentResponse) {
    set.removeWhere((code) => checkCode(currentCode, code) != currentResponse);
  }

  List<List<int>> minmax() {
    Map<String, int> scoreCount = {};
    Map<List<int>, int> score = {};
    List<List<int>> nextGuesses = [];
    int? _max, _min;

    for (List<int> combination in combinations) {
      for (List<int> candidate in candidateSolutions) {
        String pegScore = checkCode(combination, candidate);
        scoreCount.update(pegScore, (v) => v + 1, ifAbsent: () => 1);
      }

      if (scoreCount.isNotEmpty) {
        _max = scoreCount.values.reduce(max);
        score[combination] = _max;
      }
      scoreCount.clear();
    }

    if (score.isNotEmpty) {
      _min = score.values.reduce(min);

      score.forEach((key, value) {
        if (value == _min) {
          nextGuesses.add(key);
        }
      });
    }

    return nextGuesses;
  }

  int getMaxScore(Map<String, int> inputMap) {
    return inputMap.values.reduce(max);
  }

  int getMinScore(Map<List<int>, int> inputMap) {
    return inputMap.values.reduce(min);
  }

  List<int> getNextGuess(List<List<int>> nextGuesses) {
    for (List<int> guess in nextGuesses) {
      if (candidateSolutions.contains(guess)) {
        return guess;
      }
    }
    for (List<int> guess in nextGuesses) {
      if (combinations.contains(guess)) {
        return guess;
      }
    }
    return [];
  }
}
