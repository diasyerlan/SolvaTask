part of 'game_bloc.dart';

@immutable
sealed class GameEvent {}

class InitializeGame extends GameEvent {
  final int? maxNumber;
  final int? attempts;  

  InitializeGame({this.maxNumber, this.attempts});
}

class StartGame extends GameEvent {
  final int maxNumber;
  final int attempts;  

  StartGame({required this.maxNumber, required this.attempts});
}

class SubmitGuess extends GameEvent {
  final int guess; 

  SubmitGuess(this.guess);
}

class OpenSettings extends GameEvent {}

class SaveSettings extends GameEvent {
  final int maxNumber;
  final int attempts;

  SaveSettings({required this.maxNumber, required this.attempts});
}
