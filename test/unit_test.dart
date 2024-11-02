import 'package:flutter_test/flutter_test.dart';
import 'package:solva_app/bloc/bloc/game_bloc.dart';

void main() {
  group('GameBloc', () {
    late GameBloc gameBloc;

    setUp(() {
      gameBloc = GameBloc();
    });

    test('Начальное состояние должно быть GameInitial', () {
      expect(gameBloc.state, isA<GameInitial>());
    });

    test('Инициализация игры устанавливает максимальное число и попытки',
        () async {
      gameBloc.add(InitializeGame(maxNumber: 1, attempts: 1));
      await expectLater(
        gameBloc.stream,
        emitsInOrder([
          isA<GameInitial>(),
        ]),
      );
      expect(gameBloc.state, isA<GameInitial>());
      expect((gameBloc.state as GameInitial).maxNumber, 1);
      expect((gameBloc.state as GameInitial).attempts, 1);
    });

    test('Правильный ответ', () async {
      gameBloc.add(StartGame(maxNumber: 1, attempts: 1));
      await expectLater(
        gameBloc.stream,
        emitsInOrder([
          isA<GameInProgress>(),
        ]),
      );

      gameBloc.add(SubmitGuess(1));
      await expectLater(
        gameBloc.stream,
        emitsInOrder([
          isA<GameSuccess>(),
        ]),
      );
    });

    test('Неправильный ответ', () async {
      gameBloc.add(StartGame(maxNumber: 1, attempts: 1));
      await expectLater(
        gameBloc.stream,
        emitsInOrder([
          isA<GameInProgress>(),
        ]),
      );

      gameBloc.add(SubmitGuess(10));
      await expectLater(
        gameBloc.stream,
        emitsInOrder([
          isA<GameFailure>(),
        ]),
      );
    });
  });
}

