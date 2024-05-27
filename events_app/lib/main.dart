import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:events_app/presentation/screens/splash_screen.dart';
import 'package:events_app/bloc/auth_bloc/auth_bloc.dart';
import 'bloc/booking_bloc/book_bloc.dart';
import 'bloc/event_bloc/event_bloc.dart';
import 'bloc/user_bloc/user_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => EventBloc()),
        BlocProvider(create: (_) => BookingBloc()),
        BlocProvider(create: (_) => UserBloc()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
