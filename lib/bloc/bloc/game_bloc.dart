import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameInitial(maxNumber: 100, attempts: 20)) {
    on<InitializeGame>((event, emit) async {
      emit(GameInitial(maxNumber: event.maxNumber, attempts: event.attempts));
    });

    on<StartGame>((event, emit) async {
      final random = Random();
      final targetNumber = random.nextInt(event.maxNumber) + 1;
      emit(GameInProgress(
          maxNumber: event.maxNumber,
          attemptsLeft: event.attempts,
          targetNumber: targetNumber,
          guessMessage: 'Start guessing!'));
    });

    on<SubmitGuess>((event, emit) async {
      final currentState = state;
      if (currentState is GameInProgress) {
        final guess = event.guess;
        String message;

        if (guess == currentState.targetNumber) {
          emit(GameSuccess(targetNumber: currentState.targetNumber));
        } else if (currentState.attemptsLeft == 1) {
          emit(GameFailure(targetNumber: currentState.targetNumber));
        } else {
          message =
              guess < currentState.targetNumber ? 'Too low!' : 'Too high!';
          emit(GameInProgress(
            maxNumber: currentState.maxNumber,
            attemptsLeft: currentState.attemptsLeft - 1,
            targetNumber: currentState.targetNumber,
            guessMessage: message,
          ));
        }
      }
    });

    on<OpenSettings>((event, emit) async {
      emit(GameSettings(
        maxNumber: (state is GameInProgress)
            ? (state as GameInProgress).maxNumber
            : 100,
        attempts: (state is GameInProgress)
            ? (state as GameInProgress).attemptsLeft
            : 5,
      ));
    });
  }
}
