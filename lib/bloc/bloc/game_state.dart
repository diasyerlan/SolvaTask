part of 'game_bloc.dart';

@immutable
sealed class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

final class GameInitial extends GameState {
  final int maxNumber;
  final int attempts;

  const GameInitial({this.maxNumber = 100, this.attempts = 5});

  @override
  List<Object> get props => [maxNumber, attempts];
}

class GameInProgress extends GameState {
  final int maxNumber;
  final int attemptsLeft;
  final int targetNumber;
  final String guessMessage;

  const GameInProgress({required this.maxNumber, required this.attemptsLeft, required this.targetNumber, this.guessMessage = ''});

  @override
  List<Object?> get props => [maxNumber, attemptsLeft, targetNumber, guessMessage];


}

class GameSuccess extends GameState {
  final int targetNumber;

  const GameSuccess({required this.targetNumber});
  
  @override
  List<Object> get props => [targetNumber];
}

class GameFailure extends GameState {
  final int targetNumber;

  const GameFailure({required this.targetNumber});
  
  @override
  List<Object> get props => [targetNumber];
}

class GameSettings extends GameState {
  final int maxNumber;
  final int attempts; 

  const GameSettings({
    required this.maxNumber,
    required this.attempts,
  });
  
  @override
  List<Object> get props => [maxNumber, attempts];
  }
