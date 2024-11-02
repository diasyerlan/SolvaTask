import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solva_app/bloc/bloc/game_bloc.dart';
import 'package:solva_app/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GameBloc()..add(InitializeGame(maxNumber: 100, attempts: 20)))
      ],
      child: ScreenUtilInit(
        designSize: const Size(430, 1990), // Example design size
        minTextAdapt: true, 
        builder: (context, child) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: MainScreen(),
          );
        },
      ),
    );
  }
}
