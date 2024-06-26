import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'game_event_event.dart';
part 'game_event_state.dart';

class GameEventBloc extends Bloc<GameEventEvent, GameEventState> {
  GameEventBloc() : super(GameEventInitial()) {
    on<GameEventEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
