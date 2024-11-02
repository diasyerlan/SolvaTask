part of 'game_bloc.dart';

@immutable
abstract class GameEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitializeGame extends GameEvent {
  final int maxNumber;
  final int attempts;

  InitializeGame({required this.maxNumber, required this.attempts});

  @override
  List<Object?> get props => [maxNumber, attempts];
}

class StartGame extends GameEvent {
  final int maxNumber;
  final int attempts;

  StartGame({required this.maxNumber, required this.attempts});

  @override
  List<Object?> get props => [maxNumber, attempts];
}

class SubmitGuess extends GameEvent {
  final int guess;

  SubmitGuess(this.guess);

  @override
  List<Object?> get props => [guess];
}

class OpenSettings extends GameEvent {}

