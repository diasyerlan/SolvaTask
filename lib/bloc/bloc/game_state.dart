part of 'game_bloc.dart';

@immutable
abstract class GameState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {
  final int maxNumber;
  final int attempts;

  GameInitial({required this.maxNumber, required this.attempts});

  @override
  List<Object?> get props => [maxNumber, attempts];
}

class GameInProgress extends GameState {
  final int maxNumber;
  final int attemptsLeft;
  final int targetNumber;
  final String guessMessage;

  GameInProgress({
    required this.maxNumber,
    required this.attemptsLeft,
    required this.targetNumber,
    required this.guessMessage,
  });

  @override
  List<Object?> get props =>
      [maxNumber, attemptsLeft, targetNumber, guessMessage];
}

class GameSuccess extends GameState {
  final int targetNumber;

  GameSuccess({required this.targetNumber});

  @override
  List<Object?> get props => [targetNumber];
}

class GameFailure extends GameState {
  final int targetNumber;

  GameFailure({required this.targetNumber});

  @override
  List<Object?> get props => [targetNumber];
}

class GameSettings extends GameState {
  final int maxNumber;
  final int attempts;

  GameSettings({required this.maxNumber, required this.attempts});

  @override
  List<Object?> get props => [maxNumber, attempts];
}
