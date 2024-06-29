part of 'game_bloc.dart';

// Game State
class GameState {
  final GameMode mode;
  final Guesser guesser;
  final bool switchPlayers;
  final bool gameOver;

  int player1Score;
  int player2Score;

  final List<List<int>> guesses;
  final List<int> currentGuess;
  final List<int> currentFeedback;
  final List<List<int>> feedback;
  final List<int> solution;

  GameState({
    this.guesser = Guesser.player1,
    this.mode = GameMode.computer,
    this.guesses = const [],
    this.currentGuess = const [],
    this.feedback = const [],
    this.solution = const [],
    this.switchPlayers = false,
    this.currentFeedback = const [],
    this.player1Score = 0,
    this.player2Score = 0,
    this.gameOver = false,
  });

  GameState copyWith({
    Guesser? guesser,
    List<List<int>>? guesses,
    List<int>? currentGuess,
    List<List<int>>? feedback,
    List<int>? solution,
    GameMode? mode,
    bool? switchPlayers,
    List<int>? currentFeedback,
    int? player1Score,
    int? player2Score,
    bool? gameOver,
  }) {
    return GameState(
      guesses: guesses ?? this.guesses,
      currentGuess: currentGuess ?? this.currentGuess,
      feedback: feedback ?? this.feedback,
      solution: solution ?? this.solution,
      mode: mode ?? this.mode,
      guesser: guesser ?? this.guesser,
      switchPlayers: switchPlayers ?? this.switchPlayers,
      currentFeedback: currentFeedback ?? this.currentFeedback,
      player1Score: player1Score ?? this.player1Score,
      player2Score: player2Score ?? this.player2Score,
      gameOver: gameOver ?? this.gameOver,
    );
  }
}
