import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solva_app/bloc/bloc/game_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _maxNumController = TextEditingController();
  final TextEditingController _attemptsController = TextEditingController();
  final TextEditingController _guessController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _maxNumController.text = '100';
    _attemptsController.text = '10';
    _guessController.text = '0';

    _maxNumController.addListener(_updateButtonState);
    _attemptsController.addListener(_updateButtonState);
    _guessController.addListener(_updateButtonState);
  }

  bool get _isSettingsInputValid {
    final maxNum = int.tryParse(_maxNumController.text) ?? 0;
    final attempts = int.tryParse(_attemptsController.text) ?? 0;
    return maxNum > 0 && attempts > 0;
  }

  bool get _isSubmitInputValid {
    final guess = int.tryParse(_guessController.text) ?? 0;
    return guess > 0;
  }

  void _updateButtonState() {
    setState(() {});
  }

  @override
  void dispose() {
    _maxNumController.dispose();
    _attemptsController.dispose();
    _guessController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GameBloc()..add(InitializeGame(maxNumber: 100, attempts: 20)),
      child: GestureDetector(
        onTap: () {FocusScope.of(context).unfocus();},
        child: Scaffold(
          backgroundColor: Colors.deepPurple[100],
          body: BlocBuilder<GameBloc, GameState>(builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: _buildStateContent(context, state),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildStateContent(BuildContext context, GameState state) {
    if (state is GameInitial) {
      return _buildInitialScreen(context, state);
    } else if (state is GameInProgress) {
      return _buildGameScreen(context, state);
    } else if (state is GameSuccess) {
      return _buildResultScreen(context, state);
    } else if (state is GameFailure) {
      return _buildResultScreen(context, state);
    } else if (state is GameSettings) {
      return _buildSettingsScreen(context);
    }
    return const Center(child: CircularProgressIndicator());
  }

  Container _buildResultScreen(BuildContext context, GameState state) {
    return Container(
      width: double.infinity,
      color: state is GameSuccess ? Colors.green : Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Text(state is GameSuccess ? 'Congrats!' : 'Game Over!', style: TextStyle(fontSize: 20.sp),)),
          Center(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: state is GameFailure
                        ? 'The number was '
                        : 'You guessed the number',style: TextStyle(fontSize: 20.sp)
                  ),
                  if (state is GameFailure)
                    TextSpan(
                      text: '${state.targetNumber}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                    ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              BlocProvider.of<GameBloc>(context).add(StartGame(
                maxNumber: int.parse(_maxNumController.text),
                attempts: int.parse(_attemptsController.text),
              ));
            },
            child: Text(
              'Play Again',
              style: GoogleFonts.play(
                  fontWeight: FontWeight.bold, fontSize: 32.sp),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildSettingsScreen(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Max number',
                  style: GoogleFonts.play(fontSize: 20.sp),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Attempts',
                  style: GoogleFonts.play(fontSize: 20.sp),
                ),
              ],
            ),
            SizedBox(width: 10.w),
            Column(
              children: [
                CustomTextField(controller: _maxNumController),
                SizedBox(height: 18.h),
                CustomTextField(controller: _attemptsController)
              ],
            ),
          ],
        ),
        SizedBox(height: 20.h),
        GestureDetector(
          onTap: () {
            if (_isSettingsInputValid) {
              BlocProvider.of<GameBloc>(context).add(
                InitializeGame(
                  maxNumber: int.parse(_maxNumController.text),
                  attempts: int.parse(_attemptsController.text),
                ),
              );
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              color: _isSettingsInputValid
                  ? Colors.deepPurple
                  : Colors.deepPurple[300],
              child: Text(
                'Save',
                style: GoogleFonts.play(color: Colors.white, fontSize: 20.sp),
              ),
            ),
          ),
        )
      ],
    );
  }

  Padding _buildGameScreen(BuildContext context, GameInProgress state) {
    return Padding(
      padding:  EdgeInsets.all(16.w),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Text(
              'Guess a number between 1 and ${state.maxNumber}',
              style: GoogleFonts.play(fontSize: 32.sp),
              textAlign: TextAlign.center,
            ),
            Column(
              children: [
                Text(state.guessMessage, style: TextStyle(fontSize: 18.sp),),
                SizedBox(height: 24.h,),
         
                 CustomTextField(controller: _guessController),
                SizedBox(height: 14.h,),
                GestureDetector(
                  onTap: () {
                    if (_isSubmitInputValid) {
                      BlocProvider.of<GameBloc>(context)
                          .add(SubmitGuess(int.parse(_guessController.text)));
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.w),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      color: _isSubmitInputValid
                          ? Colors.deepPurple
                          : Colors.deepPurple[300],
                      child: Text(
                        'Submit',
                        style: GoogleFonts.play(
                            color: Colors.white, fontSize: 20.sp),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Text('You have ${state.attemptsLeft} attempts left', style: TextStyle(fontSize: 18.sp),),
              ],
            ),
            const SizedBox(),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: GestureDetector(
                onTap: () {
                  BlocProvider.of<GameBloc>(context).add(
                    InitializeGame(
                      maxNumber: int.parse(_maxNumController.text),
                      attempts: int.parse(_attemptsController.text),
                    ),
                  );
                },
                child:  Text(
                  'End the game',
                  style: TextStyle(color: Colors.deepPurple, fontSize: 18.sp),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _buildInitialScreen(BuildContext context, GameInitial state) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<GameBloc>(context).add(
            StartGame(maxNumber: state.maxNumber, attempts: state.attempts));
      },
      child: Scaffold(
        backgroundColor: Colors.deepPurple[100],
        body: Padding(
          padding: EdgeInsets.all(8.w),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<GameBloc>(context).add(OpenSettings());
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.w),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      color: Colors.deepPurple,
                      child: Text(
                        'Settings',
                        style: GoogleFonts.play(
                            color: Colors.white, fontSize: 20.sp),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                 Text(
                  'Tap anywhere to play',
                  style: TextStyle(color: Colors.deepPurple, fontSize: 18.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.h,
      width: 100.w,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0.w),
              borderSide: BorderSide(width: 1.w)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0.w),
              borderSide: BorderSide(width: 1.w)),
          contentPadding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
        ),
      ),
    );
  }
}
