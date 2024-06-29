part of 'game_bloc.dart';

class GameEvent {}

class AddColourToGuess extends GameEvent {
  final int colorIndex;

  AddColourToGuess(this.colorIndex);
}

class SubmitGuess extends GameEvent {}

class ResetGame extends GameEvent {}

class RemoveColourFromGuess extends GameEvent {
  final int position;

  RemoveColourFromGuess(this.position);
}

class StartGame extends GameEvent {
  final GameMode mode;

  StartGame(this.mode);
}

class SetCode extends GameEvent {
  final List<int> code;

  SetCode(this.code);
}

class SetSwitchPlayers extends GameEvent {}

class ComputerTurnEvent extends GameEvent {}

class AddColourToFeedback extends GameEvent {
  final int colorIndex;

  AddColourToFeedback(this.colorIndex);
}

class SubmitFeedback extends GameEvent {}

class SetSolutionSet extends GameEvent {
  final bool solutionSet;

  SetSolutionSet(this.solutionSet);
}
