// routes.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:events_app/presentation/screens/splash_screen.dart';
import 'package:events_app/presentation/screens/sign_in_screen.dart';
import 'package:events_app/presentation/screens/sign_up_screen.dart';
import 'package:events_app/presentation/screens/admin_homepage_screen.dart';
import 'package:events_app/presentation/screens/events_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/signin',
      builder: (context, state) => SignInScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => SignUpScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminHomePage(),
    ),
    GoRoute(
      path: '/events',
      builder: (context, state) => const EventsScreen(),
    ),
  ],
);
