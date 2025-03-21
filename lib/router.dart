import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tacgportal/screens/Home.dart';
import 'package:tacgportal/screens/Login.dart';
import 'package:tacgportal/screens/test.dart';
import 'package:tacgportal/theme.dart';
import 'package:tacgportal/widgets/colorscheme.dart';

enum AppRoute {
  login,
  home,
  testy,
  color,
}
ColorScheme colorScheme = MaterialTheme.lightScheme();
GoRouter goRouter = GoRouter(
  redirect: (context, state) {
    final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final bool isGoingToLogin = state.uri.path == '/login';

    if (!isLoggedIn && !isGoingToLogin) {
      return '/login?redirect=${state.uri.path}';
    }

    if (isLoggedIn && isGoingToLogin) {
      return '/';
    }

    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const Login();
      },
    ),
    GoRoute(
      path: '/login',
      name: AppRoute.login.name,
      builder: (context, state) {
        return const Login();
      },
    ),
    GoRoute(
      path: '/home',
      name: AppRoute.home.name,
      builder: (context, state) {
        return const Home();
      },
    ),
    GoRoute(
      path: '/testy',
      name: AppRoute.testy.name,
      builder: (context, state) {
        return const TestPage();
      },
    ),
    GoRoute(
      path: '/color',
      name: AppRoute.color.name,
      builder: (context, state) {
        return ColorSchemeDisplay(colorScheme: colorScheme);
      },
    )
  ],
);
