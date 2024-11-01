import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solva_app/bloc/bloc/game_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc()..add(InitializeGame()),
      child: Scaffold(
          backgroundColor: Colors.deepPurple[100],
          body: SafeArea(
            child: BlocBuilder<GameBloc, GameState>(builder: (context, state) {
              if (state is GameInitial) {
                return _buildInitialScreen(context);
              } else if (state is GameInProgress) {
                return _buildGameScreen(state);
              } else if (state is GameSuccess) {
              } else if (state is GameFailure) {
              } else if (state is GameSettings) {
                return Center(child: Text('Settings'),);
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
          )),
    );
  }

  Padding _buildGameScreen(GameInProgress state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Guess a number between 1 and ${state.maxNumber}',
              style: GoogleFonts.play(fontSize: 20),
            ),
             Container(
              height: 40,
              width: 100,
               child: TextField( 
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(width: 2)
                    
                   ),
                   contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 10)
                  ),
                           ),
             ),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildInitialScreen(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<GameBloc>(context)
            .add(StartGame(maxNumber: 100, attempts: 10));
      },
      child: Scaffold(
        backgroundColor: Colors.deepPurple[100],
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  BlocProvider.of<GameBloc>(context).add(OpenSettings());
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: Colors.deepPurple,
                    child: Text(
                      'Settings',
                      style: GoogleFonts.play(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              Center(
                  child: Text(
                'Tap to play',
                style: TextStyle(color: Colors.deepPurple),
              )),
              SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
